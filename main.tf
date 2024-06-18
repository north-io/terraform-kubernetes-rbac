module "roles" {
  source = "./modules/rbac"

  for_each = { for k, v in var.roles : k => v if var.create }

  create = try(each.value.create, true)

  annotations = try(var.annotations, null)
  labels      = try(var.labels, null)

  create_role    = try(each.value.create_role, true)
  role_name      = each.key
  role_namespace = try(each.value.role_namespace, null)
  role_rules     = try(each.value.role_rules, [])

  role_binding_name      = try(each.value.role_binding_name, null)
  role_binding_namespace = try(each.value.role_binding_namespace, null)
  role_binding_subjects  = try(each.value.role_binding_subjects, null)

  depends_on = [ kubectl_manifest.role_namespace ]
}



resource "kubectl_manifest" "role_namespace" {
  for_each = toset(
    concat(
      [ for k, v in var.roles : v.role_binding_namespace != null ? v.role_binding_namespace : v.role_namespace ],
      [ for k, v in var.cluster_roles : v.role_binding_namespace ]
    )
  )
  ## resource will not be deleted for safety
  apply_only = true 
  # apply_only = try(var.only_create_namespace, true)
  force_conflicts = try(var.resolve_conflicts, true)
  yaml_body = <<YAML
apiVersion: v1
kind: Namespace
metadata:
  name: ${each.value}
YAML
}

module "cluster_roles" {
  source = "./modules/rbac"

  for_each = { for k, v in var.cluster_roles : k => v if var.create }

  create = try(each.value.create, true)

  annotations = try(var.annotations, null)
  labels      = try(var.labels, null)

  create_cluster_role = try(each.value.create_cluster_role, true)
  ### using cluster_role_name allow to use the same cluster role for rolebinding in different namespaces
  cluster_role_name   = try(each.value.cluster_role_name, each.key)
  cluster_role_rules  = try(each.value.cluster_role_rules, [])

  cluster_role_binding_name     = try(each.value.cluster_role_binding_name, null)
  cluster_role_binding_subjects = try(each.value.cluster_role_binding_subjects, null)

  # Ignored when cluster_role_binding_name is provided
  role_binding_name      = try(each.value.role_binding_name, null)
  role_binding_namespace = try(each.value.role_binding_namespace, null)
  role_binding_subjects  = try(each.value.role_binding_subjects, null)


  depends_on = [ kubectl_manifest.role_namespace ]
}
