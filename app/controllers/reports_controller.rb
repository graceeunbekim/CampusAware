class ReportsController < ApplicationController

  def index
  end

  def new
    @report = Report.new
  end


  def create
    binding.pry
    @report = Report.create(report_params)
    if current_user
      lat = @report.convert_to_latlng["lat"]
      long = @report.convert_to_latlng["lng"]
      @report.update(user_id: current_user.id, lat: lat, long: long)
    end

    redirect_to reports_path
  end


  def get_geo
  schools = School.within(2, :origin => [params[:lat], params[:lng]])
  @close_schools = []
  schools.each do |school|
    if school.lat != nil
      @close_schools << school
    end
  end
    respond_to do |format|
      format.json
    end
  end

  def show_reports
    @reports = Report.all
    respond_to do |format|
      format.json
    end
  end





  private

  def report_params
    params.require(:report).permit(:title, :description, :street_number, :street_name, :city, :state, :zip_code, :bystander_or_victim, report_type_ids: [])
  end

end
