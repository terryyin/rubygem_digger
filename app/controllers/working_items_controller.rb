class WorkingItemsController < ApplicationController
  before_action :set_working_item, only: [:submit_job, :show, :edit, :update, :destroy]

  def regenerate
    WorkingItem.regenerate
    redirect_to '/'
  end

  def apply_job
    render json: [WorkingItem.apply_job!].compact
  end

  def submit_job
    @working_item.done(working_item_params[:upload])
    render json: '"ok"'
  end

  def download
    send_file RubygemDigger::CachedPackage.default_gems_path.join("gems/#{params['id']}.gem")
  end

  # GET /working_items
  # GET /working_items.json
  def index
    @working_items = WorkingItem.all
  end

  # GET /working_items/1
  # GET /working_items/1.json
  def show; end

  # GET /working_items/new
  def new
    @working_item = WorkingItem.new
  end

  # GET /working_items/1/edit
  def edit; end

  #
  # POST /working_items
  # POST /working_items.json
  def create
    @working_item = WorkingItem.new(working_item_params)

    respond_to do |format|
      if @working_item.save
        format.html { redirect_to @working_item, notice: 'Working item was successfully created.' }
        format.json { render :show, status: :created, location: @working_item }
      else
        format.html { render :new }
        format.json { render json: @working_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /working_items/1
  # PATCH/PUT /working_items/1.json
  def update
    respond_to do |format|
      if @working_item.update(working_item_params)
        format.html { redirect_to @working_item, notice: 'Working item was successfully updated.' }
        format.json { render :show, status: :ok, location: @working_item }
      else
        format.html { render :edit }
        format.json { render json: @working_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /working_items/1
  # DELETE /working_items/1.json
  def destroy
    @working_item.destroy
    respond_to do |format|
      format.html { redirect_to working_items_url, notice: 'Working item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_working_item
    @working_item = WorkingItem.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def working_item_params
    params.require(:working_item).permit(:work_type, :content, :version, :status, :upload)
  end
end
