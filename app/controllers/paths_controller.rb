class PathsController < ApplicationController
  before_action :set_path, only: %i[ show edit update destroy ]

  # GET /paths or /paths.json
  def index
    @paths = Path.all
  end

  # GET /paths/1 or /paths/1.json
  def show
    @paths = Path.all
  end

  # GET /paths/new
  def new
    @path = Path.new
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

    if @path.may_mark_enqueued?
      @path.mark_enqueued!
      DownloadWorker.perform_async(task: "download_path", path_id: @path.id)
    end

    redirect_to request.referer
  end

  def cancel_download
    @path = Path.find(params[:id])

    @path.cancel! if @path.may_cancel?

    redirect_to request.referer
  end

  private

  def set_path
    @path = Path.find(params[:id])
  end

  def path_params
    params.fetch(:path, {})
  end
end
