require 'rubygem_digger/cacheable'
require 'tmpdir'
require 'open3'
require 'json'

module RubygemDigger
  class PackageWrapper
    def initialize(base_path, name, version)
      @gems_path = base_path
      @name = name
      @version = version
    end

    def self.lizard_fields
      %w(nloc avg_ccn avg_nloc avg_token fun_count warning_count fun_rate nloc_rate)
    end

    def self.no_averaging
      %w(nloc avg_ccn avg_nloc avg_token fun_count fun_rate nloc_rate)
    end

    def self.rubocop_field_names
      [
        'Style/',
        'Performance/',
        'Security/',
        'Lint/',
        'Lint/Duplicate',
        'Metrics/',
        'Metrics/AbcSize',
        'Metrics/BlockLength',
        'Metrics/BlockNesting',
        'Metrics/ClassLength',
        'Metrics/CyclomaticComplexity',
        'Metrics/LineLength',
        'Metrics/MethodLength',
        'Metrics/ModuleLength',
        'Metrics/ParameterLists',
        'Metrics/PerceivedComplexity',
        'Total'
      ]
    end

    def self.reek_fields
      %w(DuplicateMethodCall FeatureEnvy IrresponsibleModule NilCheck TooManyConstants TooManyMethods UncommunicativeVariableName TooManyStatements UnusedParameters InstanceVariableAssumption TooManyInstanceVariables UtilityFunction PrimaDonnaMethod NestedIterators DataClump UncommunicativeMethodName LongParameterList UncommunicativeParameterName ControlParameter ManualDispatch RepeatedConditional Attribute BooleanParameter SubclassedFromCoreClass UncommunicativeModuleName ModuleInitialize ClassVariable LongYieldList)
    end

    def self.cop_field_from_name(name)
      name.downcase.tr('/', '_')
    end

    def self.rubocop_fields
      rubocop_field_names.collect { |c| cop_field_from_name(c) }
    end

    def self.all_fields
      lizard_fields + rubocop_fields + reek_fields + ['reek_total']
    end

    all_fields.each do |w|
      if no_averaging.include? w
        define_method(w) do
          stats[w.to_sym]
        end
      else
        define_method(w) do
          (stats[w.to_sym] || 0) * 1000 / stats[:nloc].to_f
        end
      end
    end

    attr_reader :name

    attr_reader :version

    def all_smells
      @all_smells ||= begin
                        JSON.parse(output[:reek]).collect { |x| x['smell_type'] }
                      rescue JSON::ParserError
                        []
                      end
    end

    def stats
      @_stats ||= analyze || {}
    end

    def stats_for_report
      self.class.all_fields.collect do |w|
        [w, send(w)]
      end.to_h
    end

    def stats_with_delta(package)
      stats_for_report.merge(delta(package))
    end

    def delta(package)
      self.class.all_fields.collect do |w|
        ["delta_#{w}", package.send(w) - send(w)]
      end.to_h
    end

    private

    def output
      @output ||= Dir.mktmpdir do |dir|
        package.extract_files dir
        {
          lizard: `lizard -lruby -C4 #{dir}`,
          rubocop: `rubocop -fo #{dir}`,
          reek: `reek -fjson #{dir}`
        }
      end
    end

    def analyze
      if output[:lizard].scrub =~ /nloc Rt\s+\-+\s+(\d+)\s+([\d\.]+)\s+([\d\.]+)\s+([\d\.]+)\s+(\d+)\s+(\d+)\s+([\d\.]+)\s+([\d\.]+)/m
        {
          nloc: $LAST_MATCH_INFO[1].to_i,
          avg_nloc: $LAST_MATCH_INFO[2].to_f,
          avg_ccn: $LAST_MATCH_INFO[3].to_f,
          avg_token: $LAST_MATCH_INFO[4].to_f,
          fun_count: $LAST_MATCH_INFO[5].to_i,
          warning_count: $LAST_MATCH_INFO[6].to_i,
          fun_rate: $LAST_MATCH_INFO[7].to_f,
          nloc_rate: $LAST_MATCH_INFO[8].to_f
        }.tap do |h|
          output[:lizard].scrub =~ /(\d+) file analyzed\./
          h[:files] = $LAST_MATCH_INFO[1].to_i
          self.class.rubocop_field_names.each do |cop|
            h[self.class.cop_field_from_name(cop).to_sym] =
              output[:rubocop].scan(/(\d)+\s+#{cop}/)
                              .collect(&:first)
                              .collect(&:to_i)
                              .inject(0) { |sum, x| sum + x } || 0
          end

          total = 0
          self.class.reek_fields.each do |smell|
            h[smell.to_sym] = all_smells.count(smell)
            total += h[smell.to_sym]
          end

          h[:reek_total] = total
        end
      end
    end

    def package
      Gem::Package.new(filename(@version))
    end

    def filename(version)
      @gems_path.join("gems/#{@name}-#{version}.gem").to_s
    end
  end

  class CachedPackage
    include Cacheable
    self.version = 5

    def self.gems_path=(path)
      @@gems_path = path
    end

    def self.default_gems_path
      @@gems_path
    end

    def gems_path
      @gems_path || @@gems_path
    end

    def self.plan_job(context)
      [name, instance_name(context), version]
    end

    def self.context_from_content(content)
      content =~ /^(.*)\-([\d\.]+)$/
      {
        name: $LAST_MATCH_INFO[1],
        version: $LAST_MATCH_INFO[2]
      }
    end

    def self.instance_name(context)
      "#{context[:name]}-#{context[:version]}"
    end

    def create(context)
      @package = PackageWrapper.new(
        context[:gems_path] || gems_path,
        context[:name],
        context[:version]
      )
      @package.stats
    end

    PackageWrapper.all_fields.each do |w|
      define_method(w) do
        @package.send(w.to_sym)
      end
    end

    def all_smells
      @package.all_smells
    end

    def stats
      @package.stats
    end

    def stats_for_report
      @package.stats_for_report
    end

    def stats_with_delta(package)
      @package.stats_with_delta(package.package)
    rescue
      print @package.name
      raise
    end

    attr_reader :package

    def version
      @package.version
    end
  end
end
