   private SqlConnection GetSqlServerConnection()
        {
            string connectionString = @"Data Source=127.0.0.1; Initial Catalog=intellilog2; User ID=sa; Password=ilog123";
            SqlConnection connection = new SqlConnection(connectionString);
            return connection;
        }


void showPermissionGrid()
        {
            

            using (SqlConnection connection = GetSqlServerConnection())
            {  
                
                connection.Open();
                // SELECT data from the permission table
                string permissionTable = "SELECT employeeId, groupsId, SitesId , site_groupsId, permission FROM permission";
                SqlCommand command = new SqlCommand(permissionTable, connection);
                SqlDataReader reader = command.ExecuteReader();
                DataTable permissionData = new DataTable();
                permissionData.Load(reader);
                reader.Close();

                // SELECT data from the employee table
                command = new SqlCommand("SELECT id, FullName FROM employee", connection);
                reader = command.ExecuteReader();
                DataTable employeeData = new DataTable();
                employeeData.Load(reader);
                reader.Close();

                // SELECT data from the groups table
                command = new SqlCommand("SELECT id, GroupName FROM groups", connection);
                reader = command.ExecuteReader();
                DataTable groupData = new DataTable();
                groupData.Load(reader);
                reader.Close();

                // SELECT data from the sites table
                command = new SqlCommand("SELECT id, description FROM sites", connection);
                reader = command.ExecuteReader();
                DataTable siteData = new DataTable();
                siteData.Load(reader);
                reader.Close();

                // SELECT data from the site_groups table
                command = new SqlCommand("SELECT id, description FROM site_groups", connection);
                reader = command.ExecuteReader();
                DataTable site_groupsData = new DataTable();
                site_groupsData.Load(reader);
                reader.Close();


                // Create the combo box columns for user Column
                DataGridViewComboBoxColumn employeeColumn = new DataGridViewComboBoxColumn();
                employeeColumn.DataSource = employeeData;
                employeeColumn.DisplayMember = "FullName";
                employeeColumn.ValueMember = "id";
                employeeColumn.DataPropertyName = "employeeId";
                employeeColumn.HeaderText = "User";
                employeeColumn.DisplayIndex = 0;
                permissionDataGrid.Columns.Add(employeeColumn);

                // Create the combo box columns for group
                DataGridViewComboBoxColumn groupColumn = new DataGridViewComboBoxColumn();
                groupColumn.DataSource = groupData;
                groupColumn.DisplayMember = "GroupName";
                groupColumn.ValueMember = "id";
                groupColumn.DataPropertyName = "groupsId";
                groupColumn.HeaderText = "Group";
                groupColumn.DisplayIndex = 1;
                permissionDataGrid.Columns.Add(groupColumn);

                // Create the combo box columns for site
                DataGridViewComboBoxColumn siteColumn = new DataGridViewComboBoxColumn();
                siteColumn.DataSource = siteData;
                siteColumn.DisplayMember = "description";
                siteColumn.ValueMember = "id";
                siteColumn.DataPropertyName = "SitesId";
                siteColumn.HeaderText = "Site";
                siteColumn.DisplayIndex = 2;
                permissionDataGrid.Columns.Add(siteColumn);

                // Create the combo box columns for site group
                DataGridViewComboBoxColumn site_groupsColumn = new DataGridViewComboBoxColumn();
                site_groupsColumn.DataSource = site_groupsData;
                site_groupsColumn.DisplayMember = "description";
                site_groupsColumn.ValueMember = "id";
                site_groupsColumn.DataPropertyName = "site_groupsId";
                site_groupsColumn.HeaderText = "Site Group";
                site_groupsColumn.DisplayIndex = 3;
                permissionDataGrid.Columns.Add(site_groupsColumn);


                // Create the combo box columns for permission
                DataGridViewComboBoxColumn permissionColumn = new DataGridViewComboBoxColumn();
                permissionColumn.DataSource = permissionData; // This is the original data source
                var filteredPermissionData = permissionData.AsEnumerable().GroupBy(r => r.Field<string>("permission")).Select(r => r.First());
                DataTable filteredPermissionTable = permissionData.Clone();
                foreach (DataRow row in filteredPermissionData)
                    filteredPermissionTable.ImportRow(row);
                permissionColumn.DataSource = filteredPermissionTable;
                permissionColumn.DataSource = filteredPermissionTable;
                permissionColumn.DisplayMember = "permission";
                permissionColumn.DataPropertyName = "permission";
                permissionColumn.HeaderText = "Permission";
                permissionColumn.DisplayIndex = 4;
                permissionDataGrid.Columns.Add(permissionColumn);



                permissionDataGrid.DataSource = permissionData;
            }
           
