variable "create" {
  description = "Controls whether the Authorization and RBAC resources should be created (affects all resources)."
  type        = bool
  default     = true
}

variable "labels" {
  description = "The global labels. Applied to all resources."
  type        = map(string)
  default     = {}
}

variable "annotations" {
  description = "The global annotations. Applied to all resources."
  type        = map(string)
  default     = {}
}

variable "roles" {
  description = "Map of role and role binding definitions to create."
  type        = any
  default     = {}
}

variable "cluster_roles" {
  description = "Map of cluster role and cluster/role binding definitions to create."
  type        = any
  default     = {}
}

variable "only_create_namespace" {
  description = "Only create the namespace. Be careful! If you set this to false and set namespace to an existing namespace, the module will delete all resources in the namespace."
  type        = bool
  default     = true
}
 variable "resolve_conflicts" {
   description = "Resolve conflicts when applying resources."
   type        = bool
   default     = true
   
 }