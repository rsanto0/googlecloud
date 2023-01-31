provider "google" {
  project = "diniz-devops-iac"
  region = "us-weast1"
  zone = "us-weast1"
  credentials = "${file("serviceaccount.yaml")}"
}

# Folder Comercial
resource "google_folder" "Comercial" {
  display_name = "Comercial"
  parent = "organizations/164470437406"
}
resource "google_folder" "Desenvolvimento" {
  display_name = "Desenvolvimento"
  parent = google_folder.Comercial.name
}
resource "google_folder" "Producao" {
  display_name = "Producao"
  parent = google_folder.Comercial.name
}
resource "google_project" "dinizcloud-comercial-dev" {
  name = "comercial-dev"
  project_id = "dinizcloud-comercial-dev"
  folder_id = google_folder.Desenvolvimento.name
  auto_create_network = false
  billing_account = "01596D-C07827-42B66F"
}
resource "google_project" "dinizcloud-comercial-prd" {
  name = "comercial-prd"
  project_id = "dinizcloud-infra-prd"
  folder_id = google_folder.Producao.name
  auto_create_network = false
  billing_account = "01596D-C07827-42B66F"
}

# Folder Financeiro
resource "google_folder" "Financeiro" {
  display_name = "Financeiro"
  parent = "organizations/164470437406"
}
resource "google_folder" "Desenvolvimento" {
  display_name = "Desenvolvimento"
  parent = google_folder.Financeiro.name
}
resource "google_folder" "Producao" {
  display_name = "Producao"
  parent = google_folder.Financeiro.name
}
resource "google_project" "dinizcloud-financeiro-dev" {
  name = "financeiro-dev"
  project_id = "dinizcloud-financeiro-dev"
  folder_id = google_folder.Desenvolvimento.name
  auto_create_network = false
  billing_account = "01596D-C07827-42B66F"
}
resource "google_project" "dinizcloud-financeiro-prd" {
  name = "financeiro-prd"
  project_id = "dinizcloud-financeiro-prd"
  folder_id = google_folder.Producao.name
  auto_create_network = false
  billing_account = "01596D-C07827-42B66F"
}

# Folder Infraestrutura
resource "google_folder" "Infraestrutura" {
  display_name = "Infraestrutura"
  parent = "organizations/164470437406"
}
resource "google_folder" "Desenvolvimento" {
  display_name = "Desenvolvimento"
  parent = google_folder.Infraestrutura.name
}
resource "google_folder" "Producao" {
  display_name = "Producao"
  parent = google_folder.Infraestrutura.name
}
resource "google_project" "dinizcloud-infra-dev" {
  name = "Infra-dev"
  project_id = "dinizcloud-infra-dev"
  folder_id = google_folder.Desenvolvimento.name
  auto_create_network = false
  billing_account = "01596D-C07827-42B66F"
}
resource "google_project" "dinizcloud-infra-prd" {
  name = "Infra-prd"
  project_id = "dinizcloud-infra-prd"
  folder_id = google_folder.Producao.name
  auto_create_network = false
  billing_account = "01596D-C07827-42B66F"
}


provider "googleworkspace" {
  credentials             = "${file("serviceaccount.yaml")}"
  customer_id             = "C00hsqe28"
  impersonated_user_email = "rodrigo.diniz@rodrigodinizcloud.com.br"
  oauth_scopes = [
    "https://www.googleapis.com/auth/admin.directory.user",
    "https://www.googleapis.com/auth/admin.directory.userschema",
    "https://www.googleapis.com/auth/admin.directory.group"
    # include scopes as needed
  ]
}

# -----------------------------------------------------------------

resource "googleworkspace_user" "lucas" {
  primary_email = "lucas@rodrigodinizcloud.com.br"
  password      = "8770353ab5c20895b2f95075ba90541e"
  hash_function = "MD5"
  name {
    family_name = "Diniz"
    given_name  = "Lucas"
  }
}
resource "googleworkspace_user" "joao" {
  primary_email = "joao@rodrigodinizcloud.com.br"
  password      = "8770353ab5c20895b2f95075ba90541e"
  hash_function = "MD5"
  name {
    family_name = "Ninguem"
    given_name  = "Joao"
  }
}
# -----------------------------------------------------------------

#Grupos
resource "googleworkspace_group" "devops" {
  email       = "devops@rodrigodinizcloud.com.br"
  name        = "Devops"
  description = "Devops Group"
  timeouts {
    create = "1m"
    update = "1m"
  }
}

resource "googleworkspace_group" "financeiro" {
  email       = "financeiro@rodrigodinizcloud.com.br"
  name        = "Financeiro"
  description = "Financeiro Group"
  timeouts {
    create = "1m"
    update = "1m"
  }
}

#Grupos
resource "googleworkspace_group_members" "devops" {
  group_id = googleworkspace_group.devops.id
   
  members {
    email = googleworkspace_user.joao.primary_email
    role = "MEMBER"
  }
  members {
    email = googleworkspace_user.lucas.primary_email
    role = "MANAGER"
  }
}

resource "googleworkspace_group_member" "financeiro" {
  group_id = googleworkspace_group.financeiro.id
  email = googleworkspace_user.joao.primary_email
  role = "MANAGER"  
}

