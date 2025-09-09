# Redmine - project management software
# Copyright (C) 2006-2016  Jean-Philippe Lang
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

class HomeController < ApplicationController  
  skip_before_action :check_if_login_required
  skip_before_action :require_login
  skip_before_action :verify_authenticity_token
  layout false

  # Lưu thời gian khởi động ứng dụng
  @@app_start_time = Time.current

  def healthz
    current_time = Time.zone.now
    gmt7_time = current_time.in_time_zone('Asia/Bangkok')
    age = (Time.current - @@app_start_time) / 60    
    if age > 60 && 
        gmt7_time.hour == 4 && 
        gmt7_time.min <= 30
      render json: {
        status: 'stopped',
        age: age,
        app_start_time: @@app_start_time,
        gmt7_time: gmt7_time,
        current_time: current_time,
        current: Time.current,
        now: Time.zone.now,
        zone: Time.now.zone,
        zone_name: Time.zone.tzinfo.name
      }, status: :service_unavailable
    else
      render json: {
        status: 'ok',
        age: age,
        app_start_time: @@app_start_time,
        gmt7_time: gmt7_time,
        current_time: current_time,
        current: Time.current,
        now: Time.zone.now,
        zone: Time.now.zone,
        zone_name: Time.zone.tzinfo.name

      }, status: :ok
    end
  end
end
