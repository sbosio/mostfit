Merb.logger.info("Compiling routes...")
Merb::Router.prepare do
  resources :loan_types
  resources :users
  resources :staff_members
  resources :branches  do
    resources :centers  do
      resources :clients do
        resources :loans  do
          resources :payments
        end
      end
    end
  end
  resources :funders do
    resources :funding_lines
  end
  
  # Adds the required routes for merb-auth using the password slice
  slice(:merb_auth_slice_password, :name_prefix => nil, :path_prefix => "")
  match('/search').to(:controller => 'search', :action => 'index')
  match('/reports/graphs').to(:controller => 'reports', :action => 'graphs')
  match('/reports/:report_type(/:id)').to(:controller => 'reports', :action => 'show').name(:show_report)
  resources :reports

  match('/data_entry').to(:namespace => 'data_entry', :controller => 'index').name(:data_entry)
  namespace :data_entry, :name_prefix => 'enter' do  # for url(:enter_payment) and the likes
    match('/clients(/:action)(.:format)').to(:controller => 'clients').name(:clients)
    match('/loans/approve_by_center/:id').to(:controller => 'loans', :action => 'approve').name(:approval_by_center)
    match('/loans(/:action)(.:format)').to(:controller => 'loans').name(:loans)
    match('/payments(/:action)(.:format)').to(:controller => 'payments').name(:payments)
    match('/attendancy(/:action)(.:format)').to(:controller => 'attendancy').name(:attendancy)
    match('/branches(/:action)(.:format)').to(:controller => 'branches').name(:branches)
    match('/centers(/:action)(.:format)').to(:controller => 'centers').name(:centers)
  end

  match('/admin(/:action)').to(:controller => 'admin').name(:admin)
  match('/dashboard(/:action)').to(:controller => 'dashboard').name(:dashboard)

  match('/graph_data/:action(/:id)').to(:controller => 'graph_data').name(:graph_data)
  match('/staff_members/:id/centers').to(:controller => 'staff_members', :action => 'show_centers').name(:show_staff_member_centers)
  match('/branches/:id/today').to(:controller => 'branches', :action => 'today').name(:branch_today)
  match('/entrance').to(:controller => 'entrance').name(:entrance)
  match('/branches/:branch_id/centers/:center_id/clients/:client_id/test').to( :controller => 'loans', :action => 'test')
  match('/loans/latest').to(:controller => 'loans', :action => 'latest')
  match('/staff_members/:id/day_sheet').to(:controller => 'staff_members', :action => 'day_sheet').name(:day_sheet)  
  match('/staff_members/:id/day_sheet.:format').to(:controller => 'staff_members', :action => 'day_sheet', :format => ":format").name(:day_sheet_with_format)

  # this uses the redirect_to_show methods on the controllers to redirect some models to their appropriate urls
  match('/:controller/:id').to(:action => 'redirect_to_show').name(:quick_link)
  default_routes
  match('/').to(:controller => 'entrance', :action =>'root')



end
