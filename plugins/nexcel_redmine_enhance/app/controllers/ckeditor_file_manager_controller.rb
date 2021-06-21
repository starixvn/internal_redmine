class CkeditorFileManagerController < ApplicationController
  unloadable

  def upload_file
    # http://localhost:3000/projects/rd-casino-integration-improvement/dmsf/upload.xml?filename=14427672876_6d3b0f976e_o.jpg
  end

  def file_manager
    # get list of file
    # http://localhost:3000/projects/rd-casino-integration-improvement/dmsf.json
#     {
#     "dmsf": {
#         "dmsf_folders": [],
#         "total_count": 0,
#         "dmsf_files": [
#             {
#                 "id": 1213,
#                 "name": "14427672876_6d3b0f976e_o.jpg"
#             },
#             {
#                 "id": 1212,
#                 "name": "1496935817_Money.png"
#             }
#         ],
#         "dmsf_links": []
#     }
# }
    @project = params[:project]
    render :layout => false
  end
end
