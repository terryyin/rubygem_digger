class WorkingItem < ApplicationRecord
  scope :need_work, ->{where(status: nil)}
  WORKING = 1
  def self.regenerate
    RubygemDigger::Digger.new.dig do |type, content, version|
      begin
        create work_type: type, content: content, version: version
      rescue ActiveRecord::RecordNotUnique
      end
    end
  end

  def self.apply_job!
    lock.transaction do
      f = need_work.first
      f&.update(status: WORKING)
      f
    end
  end

  def done(upload)
    RubygemDigger::Cacheable.receive_upload(upload, work_type, content, version)
    destroy
  end

  def working?
    status == WORKING
  end
end
