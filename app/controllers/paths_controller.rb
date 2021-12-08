class PathsController < ApplicationController
  before_action :set_path, only: %i[ show edit update destroy ]

  # GET /paths or /paths.json
  def index
    @paths = Path.all
  end

  # GET /paths/1 or /paths/1.json
  def show
  end

  # GET /paths/new
  def new
    @path = Path.new
  end

  # GET /paths/1/edit
  def edit
  end

  # POST /paths or /paths.json
  def create
    @path = Path.new(path_params)

    respond_to do |format|
      if @path.save
        format.html { redirect_to @path, notice: "Path was successfully created." }
        format.json { render :show, status: :created, location: @path }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @path.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /paths/1 or /paths/1.json
  def update
    respond_to do |format|
      if @path.update(path_params)
        format.html { redirect_to @path, notice: "Path was successfully updated." }
        format.json { render :show, status: :ok, location: @path }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @path.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /paths/1 or /paths/1.json
  def destroy
    @path.destroy
    respond_to do |format|
      format.html { redirect_to paths_url, notice: "Path was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def download
    @path = Path.find(params[:id])

    DefaultWorker.perform_async(task: "download_path", path_id: @path.id)

    redirect_to @path.cloud_file
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_path
    @path = Path.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def path_params
    params.fetch(:path, {})
  end
end
