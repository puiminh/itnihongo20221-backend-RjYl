class TopicsController < ApplicationController
  before_action :set_topic, only: [:show, :update, :destroy]

  # GET /topics
  def index
    limit = params[:limit] || 100
    offset = params[:offset] || 0

    @topics = Topic.limit(limit).offset(offset).all
    
    render json: @topics
  end

  # GET /topics/1
  def show
    render json: @topic, include: [:posts]
  end

  # POST /topics
  def create
    authenticate_account!
    @topic = Topic.new(topic_params)

    if @topic.save
      render json: @topic, status: :created, location: @topic
    else
      render json: @topic.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /topics/1
  def update
    authenticate_account!
    if @topic.update(topic_params)
      render json: @topic
    else
      render json: @topic.errors, status: :unprocessable_entity
    end
  end

  # DELETE /topics/1
  def destroy
    authenticate_account!
    @topic.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_topic
      @topic = Topic.includes(:topics).find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def topic_params
      params.require(:topic).permit(:name)
    end
end
