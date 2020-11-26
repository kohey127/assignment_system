class EmployeesController < ApplicationController
  before_action :authenticate_manager!
  
  def index
    @employees = Employee.all
  end

  def show
    @employee = Employee.find(params[:id])
  end

  def new
    @employee = Employee.new
  end

  def create
    @employee = Employee.new(employee_params)
    if @employee.save
      flash[:success] = "社員を新規に作成しました。"
      redirect_to employees_path
    else
      render :new
    end
  end

  def edit
    @employee = Employee.find(params[:id])
  end

  def update
    @employee = Employee.find(params[:id])
    if @employee.update(employee_params)
      flash[:success] = "社員の情報を更新しました。"
      redirect_to employee_path(@employee.id)
    else
      render :edit
    end
  end

  def status_update
    binding.pry
    employee = Employee.find(params[:employee_id])
    case params[:status]
    when "open"
      employee.update(is_active: true)
      flash[:success] = "社員を有効化しました"
    when "close"
      employee.update(is_active: false)
      flash[:success] = "社員を無効化しました"
    end
    redirect_to employees_path
  end
    
  def destroy
    @employee = Employee.find(params[:id])
    if @employee.destroy
      flash[:success] = "社員を削除しました。"
      redirect_to employees_path
    else
      render :edit
    end
  end
  
  private
  def employee_params
    params.require(:employee).permit(:department_id, :grade_id, :name, :employee_id, :information, :is_active)
  end
end
