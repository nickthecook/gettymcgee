class CloudFilesController < ApplicationController
  before_action :set_cloud_file, only: %i[ show edit update destroy ]

  # GET /cloud_files or /cloud_files.json
  def index
    @cloud_files = CloudFile.all
  end

  # GET /cloud_files/1 or /cloud_files/1.json
  def show
  end

  # GET /cloud_files/new
  def new
    @cloud_file = CloudFile.new
  end

  # GET /cloud_files/1/edit
  def edit
  end

  # POST /cloud_files or /cloud_files.json
  def create
    @cloud_file = CloudFile.new(cloud_file_params)

    respond_to do |format|
      if @cloud_file.save
        format.html { redirect_to @cloud_file, notice: "Cloud file was successfully created." }
        format.json { render :show, status: :created, location: @cloud_file }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @cloud_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cloud_files/1 or /cloud_files/1.json
  def update
    respond_to do |format|
      if @cloud_file.update(cloud_file_params)
        format.html { redirect_to @cloud_file, notice: "Cloud file was successfully updated." }
        format.json { render :show, status: :ok, location: @cloud_file }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @cloud_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cloud_files/1 or /cloud_files/1.json
  def destroy
    @cloud_file.destroy
    respond_to do |format|
      format.html { redirect_to cloud_files_url, notice: "Cloud file was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cloud_file
      @cloud_file = CloudFile.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def cloud_file_params
      params.require(:cloud_file).permit(:filename, :status, :original_link, :directory, :remote_created_at)
    end
end
