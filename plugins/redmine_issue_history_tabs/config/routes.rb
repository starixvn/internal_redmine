# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

match '/customize_journals/diff/:id', :to => 'customize_journals#diff', :id => /\d+/, :via => :get