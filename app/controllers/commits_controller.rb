class CommitsController < ApplicationController
  before_action :authenticate_manager!
  
  def index
    @employees = Employee.where(is_active: true)
  end

  def show
    @projects = Project.where(status: "preparation")
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
