# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

match 'boards/index' => 's2b_boards#index', via: [:get, :post]
match 'boards/update_status' => 's2b_boards#update_status', via: [:get, :post]
match "boards/update_progress" => "s2b_boards#update_progress", via: [:get, :post]
match "boards/close_on_board" => "s2b_boards#close_on_board", via: [:get, :post]
match "boards/filter_issues_onboard" => "s2b_boards#filter_issues_onboard", via: [:get, :post]
match "boards/update" => "s2b_boards#update", via: [:get, :post]
match "boards/sort" => "s2b_boards#sort", via: [:get, :post]
match "boards/new" => "s2b_boards#new", via: [:get, :post]
match "boards/create" => "s2b_boards#create", via: [:get, :post]

match 'lists/index' => 's2b_lists#index', via: [:get, :post]
match "lists/filter_issues_onlist" => "s2b_lists#filter_issues_onlist", via: [:get, :post]
match "lists/close_on_list" => "s2b_lists#close_on_list", via: [:get, :post]
match "lists/change_sprint" => "s2b_lists#change_sprint", via: [:get, :post]
