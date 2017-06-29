# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170317082100) do

  create_table "announcements", force: :cascade do |t|
    t.text     "message",    limit: 65535
    t.integer  "project_id", limit: 4
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "api_log_for_plugins", force: :cascade do |t|
    t.text     "plugin_code", limit: 65535,                 null: false
    t.integer  "error_code",  limit: 4
    t.text     "description", limit: 65535
    t.text     "controller",  limit: 65535
    t.text     "action",      limit: 65535
    t.text     "params",      limit: 65535
    t.integer  "user_id",     limit: 4
    t.boolean  "served",                    default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attachments", force: :cascade do |t|
    t.integer  "container_id",   limit: 4
    t.string   "container_type", limit: 30
    t.string   "filename",       limit: 255, default: "", null: false
    t.string   "disk_filename",  limit: 255, default: "", null: false
    t.integer  "filesize",       limit: 8,   default: 0,  null: false
    t.string   "content_type",   limit: 255, default: ""
    t.string   "digest",         limit: 40,  default: "", null: false
    t.integer  "downloads",      limit: 4,   default: 0,  null: false
    t.integer  "author_id",      limit: 4,   default: 0,  null: false
    t.datetime "created_on"
    t.string   "description",    limit: 255
    t.string   "disk_directory", limit: 255
  end

  add_index "attachments", ["author_id"], name: "index_attachments_on_author_id", using: :btree
  add_index "attachments", ["container_id", "container_type"], name: "index_attachments_on_container_id_and_container_type", using: :btree
  add_index "attachments", ["created_on"], name: "index_attachments_on_created_on", using: :btree

  create_table "auth_sources", force: :cascade do |t|
    t.string  "type",              limit: 30,    default: "",    null: false
    t.string  "name",              limit: 60,    default: "",    null: false
    t.string  "host",              limit: 60
    t.integer "port",              limit: 4
    t.string  "account",           limit: 255
    t.string  "account_password",  limit: 255,   default: ""
    t.string  "base_dn",           limit: 255
    t.string  "attr_login",        limit: 30
    t.string  "attr_firstname",    limit: 30
    t.string  "attr_lastname",     limit: 30
    t.string  "attr_mail",         limit: 30
    t.boolean "onthefly_register",               default: false, null: false
    t.boolean "tls",                             default: false, null: false
    t.text    "filter",            limit: 65535
    t.integer "timeout",           limit: 4
  end

  add_index "auth_sources", ["id", "type"], name: "index_auth_sources_on_id_and_type", using: :btree

  create_table "boards", force: :cascade do |t|
    t.integer "project_id",      limit: 4,                null: false
    t.string  "name",            limit: 255, default: "", null: false
    t.string  "description",     limit: 255
    t.integer "position",        limit: 4
    t.integer "topics_count",    limit: 4,   default: 0,  null: false
    t.integer "messages_count",  limit: 4,   default: 0,  null: false
    t.integer "last_message_id", limit: 4
    t.integer "parent_id",       limit: 4
  end

  add_index "boards", ["last_message_id"], name: "index_boards_on_last_message_id", using: :btree
  add_index "boards", ["project_id"], name: "boards_project_id", using: :btree

  create_table "changes", force: :cascade do |t|
    t.integer "changeset_id",  limit: 4,                  null: false
    t.string  "action",        limit: 1,     default: "", null: false
    t.text    "path",          limit: 65535,              null: false
    t.text    "from_path",     limit: 65535
    t.string  "from_revision", limit: 255
    t.string  "revision",      limit: 255
    t.string  "branch",        limit: 255
  end

  add_index "changes", ["changeset_id"], name: "changesets_changeset_id", using: :btree

  create_table "changeset_parents", id: false, force: :cascade do |t|
    t.integer "changeset_id", limit: 4, null: false
    t.integer "parent_id",    limit: 4, null: false
  end

  add_index "changeset_parents", ["changeset_id"], name: "changeset_parents_changeset_ids", using: :btree
  add_index "changeset_parents", ["parent_id"], name: "changeset_parents_parent_ids", using: :btree

  create_table "changesets", force: :cascade do |t|
    t.integer  "repository_id", limit: 4,          null: false
    t.string   "revision",      limit: 255,        null: false
    t.string   "committer",     limit: 255
    t.datetime "committed_on",                     null: false
    t.text     "comments",      limit: 4294967295
    t.date     "commit_date"
    t.string   "scmid",         limit: 255
    t.integer  "user_id",       limit: 4
  end

  add_index "changesets", ["committed_on"], name: "index_changesets_on_committed_on", using: :btree
  add_index "changesets", ["repository_id", "revision"], name: "changesets_repos_rev", unique: true, using: :btree
  add_index "changesets", ["repository_id", "scmid"], name: "changesets_repos_scmid", using: :btree
  add_index "changesets", ["repository_id"], name: "index_changesets_on_repository_id", using: :btree
  add_index "changesets", ["user_id"], name: "index_changesets_on_user_id", using: :btree

  create_table "changesets_issues", id: false, force: :cascade do |t|
    t.integer "changeset_id", limit: 4, null: false
    t.integer "issue_id",     limit: 4, null: false
  end

  add_index "changesets_issues", ["changeset_id", "issue_id"], name: "changesets_issues_ids", unique: true, using: :btree

  create_table "checklist_template_categories", force: :cascade do |t|
    t.string  "name",     limit: 255
    t.integer "position", limit: 4,   default: 1
  end

  create_table "checklist_templates", force: :cascade do |t|
    t.string  "name",           limit: 255
    t.integer "project_id",     limit: 4
    t.integer "category_id",    limit: 4
    t.integer "user_id",        limit: 4
    t.boolean "is_public"
    t.text    "template_items", limit: 65535
  end

  create_table "checklists", force: :cascade do |t|
    t.boolean  "is_done",                default: false
    t.string   "subject",    limit: 255
    t.integer  "position",   limit: 4,   default: 1
    t.integer  "issue_id",   limit: 4,                   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",    limit: 255, null: false
    t.string   "data_content_type", limit: 255
    t.integer  "data_file_size",    limit: 4
    t.integer  "assetable_id",      limit: 4
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width",             limit: 4
    t.integer  "height",            limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "comments", force: :cascade do |t|
    t.string   "commented_type", limit: 30,         default: "", null: false
    t.integer  "commented_id",   limit: 4,          default: 0,  null: false
    t.integer  "author_id",      limit: 4,          default: 0,  null: false
    t.text     "comments",       limit: 4294967295
    t.datetime "created_on",                                     null: false
    t.datetime "updated_on",                                     null: false
  end

  add_index "comments", ["author_id"], name: "index_comments_on_author_id", using: :btree
  add_index "comments", ["commented_id", "commented_type"], name: "index_comments_on_commented_id_and_commented_type", using: :btree

  create_table "custom_field_enumerations", force: :cascade do |t|
    t.integer "custom_field_id", limit: 4,                  null: false
    t.string  "name",            limit: 255,                null: false
    t.boolean "active",                      default: true, null: false
    t.integer "position",        limit: 4,   default: 1,    null: false
  end

  create_table "custom_fields", force: :cascade do |t|
    t.string  "type",                 limit: 30,    default: "",    null: false
    t.string  "name",                 limit: 30,    default: "",    null: false
    t.string  "field_format",         limit: 30,    default: "",    null: false
    t.text    "possible_values",      limit: 65535
    t.string  "regexp",               limit: 255,   default: ""
    t.integer "min_length",           limit: 4
    t.integer "max_length",           limit: 4
    t.boolean "is_required",                        default: false, null: false
    t.boolean "is_for_all",                         default: false, null: false
    t.boolean "is_filter",                          default: false, null: false
    t.integer "position",             limit: 4
    t.boolean "searchable",                         default: false
    t.text    "default_value",        limit: 65535
    t.boolean "editable",                           default: true
    t.boolean "visible",                            default: true,  null: false
    t.boolean "multiple",                           default: false
    t.boolean "is_for_new",                         default: true,  null: false
    t.string  "hint",                 limit: 255
    t.text    "format_store",         limit: 65535
    t.text    "description",          limit: 65535
    t.boolean "ajaxable",                           default: false
    t.boolean "dmsf_not_inheritable"
  end

  add_index "custom_fields", ["id", "type"], name: "index_custom_fields_on_id_and_type", using: :btree

  create_table "custom_fields_projects", id: false, force: :cascade do |t|
    t.integer "custom_field_id", limit: 4, default: 0, null: false
    t.integer "project_id",      limit: 4, default: 0, null: false
  end

  add_index "custom_fields_projects", ["custom_field_id", "project_id"], name: "index_custom_fields_projects_on_custom_field_id_and_project_id", unique: true, using: :btree

  create_table "custom_fields_roles", id: false, force: :cascade do |t|
    t.integer "custom_field_id", limit: 4, null: false
    t.integer "role_id",         limit: 4, null: false
  end

  add_index "custom_fields_roles", ["custom_field_id", "role_id"], name: "custom_fields_roles_ids", unique: true, using: :btree

  create_table "custom_fields_trackers", id: false, force: :cascade do |t|
    t.integer "custom_field_id", limit: 4, default: 0, null: false
    t.integer "tracker_id",      limit: 4, default: 0, null: false
  end

  add_index "custom_fields_trackers", ["custom_field_id", "tracker_id"], name: "index_custom_fields_trackers_on_custom_field_id_and_tracker_id", unique: true, using: :btree

  create_table "custom_report_series", force: :cascade do |t|
    t.integer  "custom_report_id", limit: 4
    t.string   "name",             limit: 255
    t.text     "filters",          limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "custom_report_series", ["custom_report_id"], name: "index_custom_report_series_on_custom_report_id", using: :btree

  create_table "custom_reports", force: :cascade do |t|
    t.integer  "project_id",  limit: 4
    t.integer  "user_id",     limit: 4,     default: 0,      null: false
    t.boolean  "is_public",                 default: false,  null: false
    t.string   "name",        limit: 255,   default: "",     null: false
    t.text     "description", limit: 65535
    t.string   "group_by",    limit: 255,   default: "",     null: false
    t.string   "chart_type",  limit: 255
    t.string   "null_text",   limit: 255,   default: "Null", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "custom_reports", ["project_id"], name: "index_custom_reports_on_project_id", using: :btree
  add_index "custom_reports", ["user_id"], name: "index_custom_reports_on_user_id", using: :btree

  create_table "custom_values", force: :cascade do |t|
    t.string  "customized_type", limit: 30,    default: "", null: false
    t.integer "customized_id",   limit: 4,     default: 0,  null: false
    t.integer "custom_field_id", limit: 4,     default: 0,  null: false
    t.text    "value",           limit: 65535
  end

  add_index "custom_values", ["custom_field_id"], name: "index_custom_values_on_custom_field_id", using: :btree
  add_index "custom_values", ["customized_type", "customized_id"], name: "custom_values_customized", using: :btree

  create_table "departments", force: :cascade do |t|
    t.integer  "parent_id",  limit: 4
    t.integer  "lft",        limit: 4
    t.integer  "rgt",        limit: 4
    t.string   "name",       limit: 255
    t.text     "background", limit: 65535
    t.integer  "head_id",    limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "departments", ["head_id"], name: "index_departments_on_head_id", using: :btree
  add_index "departments", ["parent_id", "lft", "rgt"], name: "index_departments_on_parent_id_and_lft_and_rgt", using: :btree

  create_table "dmsf_file_revision_accesses", force: :cascade do |t|
    t.integer  "dmsf_file_revision_id", limit: 4,             null: false
    t.integer  "action",                limit: 4, default: 0, null: false
    t.integer  "user_id",               limit: 4,             null: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  create_table "dmsf_file_revisions", force: :cascade do |t|
    t.integer  "dmsf_file_id",                 limit: 4,                  null: false
    t.integer  "source_dmsf_file_revision_id", limit: 4
    t.string   "name",                         limit: 255,                null: false
    t.string   "disk_filename",                limit: 255,                null: false
    t.integer  "size",                         limit: 8
    t.string   "mime_type",                    limit: 255
    t.string   "title",                        limit: 255,                null: false
    t.text     "description",                  limit: 65535
    t.integer  "workflow",                     limit: 4
    t.integer  "major_version",                limit: 4,                  null: false
    t.integer  "minor_version",                limit: 4,                  null: false
    t.text     "comment",                      limit: 65535
    t.integer  "deleted",                      limit: 4,     default: 0,  null: false
    t.integer  "deleted_by_user_id",           limit: 4
    t.integer  "user_id",                      limit: 4,                  null: false
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.integer  "dmsf_workflow_id",             limit: 4
    t.integer  "dmsf_workflow_assigned_by",    limit: 4
    t.datetime "dmsf_workflow_assigned_at"
    t.integer  "dmsf_workflow_started_by",     limit: 4
    t.datetime "dmsf_workflow_started_at"
    t.string   "digest",                       limit: 40,    default: "", null: false
  end

  add_index "dmsf_file_revisions", ["dmsf_file_id"], name: "index_dmsf_file_revisions_on_dmsf_file_id", using: :btree

  create_table "dmsf_files", force: :cascade do |t|
    t.integer  "container_id",       limit: 4,                       null: false
    t.integer  "dmsf_folder_id",     limit: 4
    t.string   "name",               limit: 255,                     null: false
    t.boolean  "notification",                   default: false
    t.integer  "deleted",            limit: 4,   default: 0,         null: false
    t.integer  "deleted_by_user_id", limit: 4
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.string   "container_type",     limit: 30,  default: "Project", null: false
  end

  add_index "dmsf_files", ["container_id", "container_type"], name: "index_dmsf_files_on_container_id_and_container_type", using: :btree

  create_table "dmsf_folders", force: :cascade do |t|
    t.integer  "project_id",         limit: 4,                     null: false
    t.integer  "dmsf_folder_id",     limit: 4
    t.string   "title",              limit: 255,                   null: false
    t.text     "description",        limit: 65535
    t.boolean  "notification",                     default: false
    t.integer  "user_id",            limit: 4,                     null: false
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.integer  "deleted",            limit: 4,     default: 0,     null: false
    t.integer  "deleted_by_user_id", limit: 4
  end

  add_index "dmsf_folders", ["project_id"], name: "index_dmsf_folders_on_project_id", using: :btree

  create_table "dmsf_links", force: :cascade do |t|
    t.integer  "target_project_id",  limit: 4,               null: false
    t.integer  "target_id",          limit: 4
    t.string   "target_type",        limit: 10,              null: false
    t.string   "name",               limit: 255,             null: false
    t.integer  "project_id",         limit: 4,               null: false
    t.integer  "dmsf_folder_id",     limit: 4
    t.integer  "deleted",            limit: 4,   default: 0, null: false
    t.integer  "deleted_by_user_id", limit: 4
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.string   "external_url",       limit: 255
    t.integer  "user_id",            limit: 4
  end

  add_index "dmsf_links", ["project_id"], name: "index_dmsf_links_on_project_id", using: :btree

  create_table "dmsf_locks", force: :cascade do |t|
    t.integer  "entity_id",                  limit: 4,  null: false
    t.integer  "user_id",                    limit: 4,  null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "entity_type",                limit: 4,  null: false
    t.integer  "lock_type_cd",               limit: 4,  null: false
    t.integer  "lock_scope_cd",              limit: 4,  null: false
    t.string   "uuid",                       limit: 36
    t.datetime "expires_at"
    t.integer  "dmsf_file_last_revision_id", limit: 4
  end

  add_index "dmsf_locks", ["entity_id"], name: "index_dmsf_locks_on_entity_id", using: :btree

  create_table "dmsf_public_urls", force: :cascade do |t|
    t.string   "token",        limit: 32, null: false
    t.integer  "dmsf_file_id", limit: 4,  null: false
    t.integer  "user_id",      limit: 4,  null: false
    t.datetime "expire_at",               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dmsf_public_urls", ["token"], name: "index_dmsf_public_urls_on_token", using: :btree

  create_table "dmsf_workflow_step_actions", force: :cascade do |t|
    t.integer  "dmsf_workflow_step_assignment_id", limit: 4,     null: false
    t.integer  "action",                           limit: 4,     null: false
    t.text     "note",                             limit: 65535
    t.datetime "created_at"
    t.integer  "author_id",                        limit: 4,     null: false
  end

  add_index "dmsf_workflow_step_actions", ["dmsf_workflow_step_assignment_id"], name: "index_dmsf_workflow_step_actions_on_workflow_step_assignment_id", using: :btree

  create_table "dmsf_workflow_step_assignments", force: :cascade do |t|
    t.integer "dmsf_workflow_step_id", limit: 4, null: false
    t.integer "user_id",               limit: 4, null: false
    t.integer "dmsf_file_revision_id", limit: 4, null: false
  end

  add_index "dmsf_workflow_step_assignments", ["dmsf_workflow_step_id", "dmsf_file_revision_id"], name: "index_dmsf_wrkfl_step_assigns_on_wrkfl_step_id_and_frev_id", unique: true, using: :btree

  create_table "dmsf_workflow_steps", force: :cascade do |t|
    t.integer "dmsf_workflow_id", limit: 4,  null: false
    t.integer "step",             limit: 4,  null: false
    t.integer "user_id",          limit: 4,  null: false
    t.integer "operator",         limit: 4,  null: false
    t.string  "name",             limit: 30
  end

  add_index "dmsf_workflow_steps", ["dmsf_workflow_id"], name: "index_dmsf_workflow_steps_on_dmsf_workflow_id", using: :btree

  create_table "dmsf_workflows", force: :cascade do |t|
    t.string   "name",       limit: 255,             null: false
    t.integer  "project_id", limit: 4
    t.integer  "status",     limit: 4,   default: 1, null: false
    t.datetime "updated_on"
    t.datetime "created_on"
    t.integer  "author_id",  limit: 4
  end

  create_table "documents", force: :cascade do |t|
    t.integer  "project_id",  limit: 4,     default: 0,  null: false
    t.integer  "category_id", limit: 4,     default: 0,  null: false
    t.string   "title",       limit: 255,   default: "", null: false
    t.text     "description", limit: 65535
    t.datetime "created_on"
  end

  add_index "documents", ["category_id"], name: "index_documents_on_category_id", using: :btree
  add_index "documents", ["created_on"], name: "index_documents_on_created_on", using: :btree
  add_index "documents", ["project_id"], name: "documents_project_id", using: :btree

  create_table "email_addresses", force: :cascade do |t|
    t.integer  "user_id",    limit: 4,                   null: false
    t.string   "address",    limit: 255,                 null: false
    t.boolean  "is_default",             default: false, null: false
    t.boolean  "notify",                 default: true,  null: false
    t.datetime "created_on",                             null: false
    t.datetime "updated_on",                             null: false
  end

  add_index "email_addresses", ["user_id"], name: "index_email_addresses_on_user_id", using: :btree

  create_table "enabled_modules", force: :cascade do |t|
    t.integer "project_id", limit: 4
    t.string  "name",       limit: 255, null: false
  end

  add_index "enabled_modules", ["project_id"], name: "enabled_modules_project_id", using: :btree

  create_table "enumerations", force: :cascade do |t|
    t.string  "name",          limit: 30,  default: "",    null: false
    t.integer "position",      limit: 4
    t.boolean "is_default",                default: false, null: false
    t.string  "type",          limit: 255
    t.boolean "active",                    default: true,  null: false
    t.integer "project_id",    limit: 4
    t.integer "parent_id",     limit: 4
    t.string  "position_name", limit: 30
  end

  add_index "enumerations", ["id", "type"], name: "index_enumerations_on_id_and_type", using: :btree
  add_index "enumerations", ["project_id"], name: "index_enumerations_on_project_id", using: :btree

  create_table "favorite_projects", force: :cascade do |t|
    t.integer "project_id", limit: 4
    t.integer "user_id",    limit: 4
  end

  add_index "favorite_projects", ["project_id", "user_id"], name: "index_favorite_projects_on_project_id_and_user_id", using: :btree

  create_table "global_issue_templates", force: :cascade do |t|
    t.string   "title",          limit: 255
    t.string   "issue_title",    limit: 255
    t.integer  "tracker_id",     limit: 4
    t.integer  "author_id",      limit: 4
    t.string   "note",           limit: 255
    t.text     "description",    limit: 65535
    t.boolean  "enabled",                      default: false, null: false
    t.integer  "position",       limit: 4
    t.datetime "created_on"
    t.datetime "updated_on"
    t.text     "checklist_json", limit: 65535
    t.boolean  "is_default",                   default: false, null: false
  end

  add_index "global_issue_templates", ["author_id"], name: "index_global_issue_templates_on_author_id", using: :btree
  add_index "global_issue_templates", ["tracker_id"], name: "index_global_issue_templates_on_tracker_id", using: :btree

  create_table "global_issue_templates_projects", id: false, force: :cascade do |t|
    t.integer "project_id",               limit: 4
    t.integer "global_issue_template_id", limit: 4
  end

  create_table "groups_users", id: false, force: :cascade do |t|
    t.integer "group_id", limit: 4, null: false
    t.integer "user_id",  limit: 4, null: false
  end

  add_index "groups_users", ["group_id", "user_id"], name: "groups_users_ids", unique: true, using: :btree

  create_table "import_items", force: :cascade do |t|
    t.integer "import_id", limit: 4,     null: false
    t.integer "position",  limit: 4,     null: false
    t.integer "obj_id",    limit: 4
    t.text    "message",   limit: 65535
  end

  create_table "imports", force: :cascade do |t|
    t.string   "type",        limit: 255
    t.integer  "user_id",     limit: 4,                     null: false
    t.string   "filename",    limit: 255
    t.text     "settings",    limit: 65535
    t.integer  "total_items", limit: 4
    t.boolean  "finished",                  default: false, null: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  create_table "issue_categories", force: :cascade do |t|
    t.integer "project_id",     limit: 4,  default: 0,  null: false
    t.string  "name",           limit: 60, default: "", null: false
    t.integer "assigned_to_id", limit: 4
    t.integer "parent_id",      limit: 4
    t.integer "lft",            limit: 4,  default: 0,  null: false
    t.integer "rgt",            limit: 4,  default: 0,  null: false
  end

  add_index "issue_categories", ["assigned_to_id"], name: "index_issue_categories_on_assigned_to_id", using: :btree
  add_index "issue_categories", ["project_id"], name: "issue_categories_project_id", using: :btree

  create_table "issue_relations", force: :cascade do |t|
    t.integer "issue_from_id", limit: 4,                null: false
    t.integer "issue_to_id",   limit: 4,                null: false
    t.string  "relation_type", limit: 255, default: "", null: false
    t.integer "delay",         limit: 4
  end

  add_index "issue_relations", ["issue_from_id", "issue_to_id"], name: "index_issue_relations_on_issue_from_id_and_issue_to_id", unique: true, using: :btree
  add_index "issue_relations", ["issue_from_id"], name: "index_issue_relations_on_issue_from_id", using: :btree
  add_index "issue_relations", ["issue_to_id"], name: "index_issue_relations_on_issue_to_id", using: :btree

  create_table "issue_statuses", force: :cascade do |t|
    t.string  "name",               limit: 30, default: "",    null: false
    t.boolean "is_closed",                     default: false, null: false
    t.integer "position",           limit: 4
    t.integer "default_done_ratio", limit: 4
  end

  add_index "issue_statuses", ["is_closed"], name: "index_issue_statuses_on_is_closed", using: :btree
  add_index "issue_statuses", ["position"], name: "index_issue_statuses_on_position", using: :btree

  create_table "issue_template_settings", force: :cascade do |t|
    t.integer "project_id",        limit: 4
    t.text    "help_message",      limit: 65535
    t.boolean "enabled"
    t.boolean "should_replaced",                 default: false
    t.boolean "inherit_templates",               default: false, null: false
  end

  create_table "issue_templates", force: :cascade do |t|
    t.string   "title",           limit: 255,                   null: false
    t.integer  "project_id",      limit: 4
    t.integer  "tracker_id",      limit: 4,                     null: false
    t.integer  "author_id",       limit: 4,                     null: false
    t.string   "note",            limit: 255
    t.text     "description",     limit: 65535
    t.boolean  "enabled",                       default: false, null: false
    t.datetime "created_on"
    t.datetime "updated_on"
    t.string   "issue_title",     limit: 255
    t.integer  "position",        limit: 4,     default: 1
    t.boolean  "is_default",                    default: false
    t.boolean  "enabled_sharing",               default: false
    t.text     "checklist_json",  limit: 65535
  end

  add_index "issue_templates", ["author_id"], name: "index_issue_templates_on_author_id", using: :btree
  add_index "issue_templates", ["project_id"], name: "index_issue_templates_on_project_id", using: :btree
  add_index "issue_templates", ["tracker_id"], name: "index_issue_templates_on_tracker_id", using: :btree

  create_table "issues", force: :cascade do |t|
    t.integer  "tracker_id",       limit: 4,                          null: false
    t.integer  "project_id",       limit: 4,                          null: false
    t.string   "subject",          limit: 255,        default: "",    null: false
    t.text     "description",      limit: 4294967295
    t.date     "due_date"
    t.integer  "category_id",      limit: 4
    t.integer  "status_id",        limit: 4,                          null: false
    t.integer  "assigned_to_id",   limit: 4
    t.integer  "priority_id",      limit: 4,                          null: false
    t.integer  "fixed_version_id", limit: 4
    t.integer  "author_id",        limit: 4,                          null: false
    t.integer  "lock_version",     limit: 4,          default: 0,     null: false
    t.datetime "created_on"
    t.datetime "updated_on"
    t.date     "start_date"
    t.integer  "done_ratio",       limit: 4,          default: 0,     null: false
    t.float    "estimated_hours",  limit: 24
    t.integer  "parent_id",        limit: 4
    t.integer  "root_id",          limit: 4
    t.integer  "lft",              limit: 4
    t.integer  "rgt",              limit: 4
    t.integer  "s2b_position",     limit: 4
    t.boolean  "is_private",                          default: false, null: false
    t.datetime "closed_on"
  end

  add_index "issues", ["assigned_to_id"], name: "index_issues_on_assigned_to_id", using: :btree
  add_index "issues", ["author_id"], name: "index_issues_on_author_id", using: :btree
  add_index "issues", ["category_id"], name: "index_issues_on_category_id", using: :btree
  add_index "issues", ["created_on"], name: "index_issues_on_created_on", using: :btree
  add_index "issues", ["fixed_version_id"], name: "index_issues_on_fixed_version_id", using: :btree
  add_index "issues", ["priority_id"], name: "index_issues_on_priority_id", using: :btree
  add_index "issues", ["project_id"], name: "issues_project_id", using: :btree
  add_index "issues", ["root_id", "lft", "rgt"], name: "index_issues_on_root_id_and_lft_and_rgt", using: :btree
  add_index "issues", ["status_id"], name: "index_issues_on_status_id", using: :btree
  add_index "issues", ["tracker_id"], name: "index_issues_on_tracker_id", using: :btree

  create_table "journal_details", force: :cascade do |t|
    t.integer "journal_id", limit: 4,     default: 0,  null: false
    t.string  "property",   limit: 30,    default: "", null: false
    t.string  "prop_key",   limit: 30,    default: "", null: false
    t.text    "old_value",  limit: 65535
    t.text    "value",      limit: 65535
  end

  add_index "journal_details", ["journal_id"], name: "journal_details_journal_id", using: :btree

  create_table "journals", force: :cascade do |t|
    t.integer  "journalized_id",   limit: 4,          default: 0,     null: false
    t.string   "journalized_type", limit: 30,         default: "",    null: false
    t.integer  "user_id",          limit: 4,          default: 0,     null: false
    t.text     "notes",            limit: 4294967295
    t.datetime "created_on",                                          null: false
    t.boolean  "private_notes",                       default: false, null: false
    t.datetime "updated_on"
  end

  add_index "journals", ["created_on"], name: "index_journals_on_created_on", using: :btree
  add_index "journals", ["journalized_id", "journalized_type"], name: "journals_journalized_id", using: :btree
  add_index "journals", ["journalized_id"], name: "index_journals_on_journalized_id", using: :btree
  add_index "journals", ["updated_on"], name: "index_journals_on_updated_on", using: :btree
  add_index "journals", ["user_id"], name: "index_journals_on_user_id", using: :btree

  create_table "latest_issues_setups", force: :cascade do |t|
    t.integer "max_count", limit: 4
    t.string  "side",      limit: 255
  end

  create_table "meetings", force: :cascade do |t|
    t.integer  "author_id",       limit: 4,     null: false
    t.integer  "project_id",      limit: 4,     null: false
    t.string   "subject",         limit: 80,    null: false
    t.text     "description",     limit: 65535
    t.date     "date"
    t.time     "start_hour"
    t.time     "end_hour"
    t.integer  "estimated_hours", limit: 4
    t.integer  "status",          limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "issue_id",        limit: 4
  end

  add_index "meetings", ["author_id"], name: "index_meetings_on_author_id", using: :btree
  add_index "meetings", ["issue_id"], name: "index_meetings_on_issue_id", using: :btree
  add_index "meetings", ["project_id"], name: "index_meetings_on_project_id", using: :btree

  create_table "meetings_users", id: false, force: :cascade do |t|
    t.integer "meeting_id", limit: 4, null: false
    t.integer "user_id",    limit: 4, null: false
  end

  add_index "meetings_users", ["meeting_id", "user_id"], name: "by_meeting_and_user", unique: true, using: :btree

  create_table "member_roles", force: :cascade do |t|
    t.integer "member_id",      limit: 4, null: false
    t.integer "role_id",        limit: 4, null: false
    t.integer "inherited_from", limit: 4
  end

  add_index "member_roles", ["member_id"], name: "index_member_roles_on_member_id", using: :btree
  add_index "member_roles", ["role_id"], name: "index_member_roles_on_role_id", using: :btree

  create_table "members", force: :cascade do |t|
    t.integer  "user_id",                limit: 4,   default: 0,     null: false
    t.integer  "project_id",             limit: 4,   default: 0,     null: false
    t.datetime "created_on"
    t.boolean  "mail_notification",                  default: false, null: false
    t.boolean  "dmsf_mail_notification"
    t.text     "title_format",           limit: 255
  end

  add_index "members", ["project_id"], name: "index_members_on_project_id", using: :btree
  add_index "members", ["user_id", "project_id"], name: "index_members_on_user_id_and_project_id", unique: true, using: :btree
  add_index "members", ["user_id"], name: "index_members_on_user_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.integer  "board_id",           limit: 4,                     null: false
    t.integer  "parent_id",          limit: 4
    t.string   "subject",            limit: 255,   default: "",    null: false
    t.text     "content",            limit: 65535
    t.integer  "author_id",          limit: 4
    t.integer  "replies_count",      limit: 4,     default: 0,     null: false
    t.integer  "last_reply_id",      limit: 4
    t.datetime "created_on",                                       null: false
    t.datetime "updated_on",                                       null: false
    t.boolean  "locked",                           default: false
    t.integer  "sticky",             limit: 4,     default: 0
    t.integer  "cached_votes_total", limit: 4,     default: 0
    t.integer  "cached_votes_up",    limit: 4,     default: 0
    t.integer  "cached_votes_down",  limit: 4,     default: 0
  end

  add_index "messages", ["author_id"], name: "index_messages_on_author_id", using: :btree
  add_index "messages", ["board_id"], name: "messages_board_id", using: :btree
  add_index "messages", ["cached_votes_down"], name: "index_messages_on_cached_votes_down", using: :btree
  add_index "messages", ["cached_votes_total"], name: "index_messages_on_cached_votes_total", using: :btree
  add_index "messages", ["cached_votes_up"], name: "index_messages_on_cached_votes_up", using: :btree
  add_index "messages", ["created_on"], name: "index_messages_on_created_on", using: :btree
  add_index "messages", ["last_reply_id"], name: "index_messages_on_last_reply_id", using: :btree
  add_index "messages", ["parent_id"], name: "messages_parent_id", using: :btree

  create_table "myhierarchy", id: false, force: :cascade do |t|
    t.integer "ID",               limit: 4,   default: 0,  null: false
    t.integer "Parent_Id",        limit: 4
    t.string  "Subject",          limit: 255, default: "", null: false
    t.integer "IDHierLevel",      limit: 4,   default: 0,  null: false
    t.integer "AlreadyProcessed", limit: 4,   default: 0,  null: false
  end

  add_index "myhierarchy", ["IDHierLevel"], name: "MyHier_Idx1", using: :hash

  create_table "news", force: :cascade do |t|
    t.integer  "project_id",     limit: 4
    t.string   "title",          limit: 60,    default: "", null: false
    t.string   "summary",        limit: 255,   default: ""
    t.text     "description",    limit: 65535
    t.integer  "author_id",      limit: 4,     default: 0,  null: false
    t.datetime "created_on"
    t.integer  "comments_count", limit: 4,     default: 0,  null: false
  end

  add_index "news", ["author_id"], name: "index_news_on_author_id", using: :btree
  add_index "news", ["created_on"], name: "index_news_on_created_on", using: :btree
  add_index "news", ["project_id"], name: "news_project_id", using: :btree

  create_table "open_id_authentication_associations", force: :cascade do |t|
    t.integer "issued",     limit: 4
    t.integer "lifetime",   limit: 4
    t.string  "handle",     limit: 255
    t.string  "assoc_type", limit: 255
    t.binary  "server_url", limit: 65535
    t.binary  "secret",     limit: 65535
  end

  create_table "open_id_authentication_nonces", force: :cascade do |t|
    t.integer "timestamp",  limit: 4,   null: false
    t.string  "server_url", limit: 255
    t.string  "salt",       limit: 255, null: false
  end

  create_table "people_announcements", force: :cascade do |t|
    t.string   "description", limit: 255
    t.date     "start_date"
    t.date     "end_date"
    t.string   "frequency",   limit: 255
    t.string   "kind",        limit: 255
    t.boolean  "active",                  default: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  create_table "people_holidays", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.date     "start_date"
    t.date     "end_date"
    t.text     "description", limit: 65535
    t.boolean  "is_workday"
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  create_table "people_information", primary_key: "user_id", force: :cascade do |t|
    t.string  "phone",           limit: 255
    t.string  "address",         limit: 255
    t.string  "skype",           limit: 255
    t.date    "birthday"
    t.string  "job_title",       limit: 255
    t.string  "company",         limit: 255
    t.string  "middlename",      limit: 255
    t.integer "gender",          limit: 1
    t.string  "twitter",         limit: 255
    t.string  "facebook",        limit: 255
    t.string  "linkedin",        limit: 255
    t.text    "background",      limit: 65535
    t.date    "appearance_date"
    t.integer "department_id",   limit: 4
    t.boolean "is_system",                     default: false
    t.integer "manager_id",      limit: 4
  end

  create_table "people_work_experiences", force: :cascade do |t|
    t.string   "previous_company_name", limit: 255
    t.string   "job_title",             limit: 255
    t.datetime "from_date"
    t.datetime "to_date"
    t.text     "description",           limit: 65535
    t.integer  "user_id",               limit: 4
  end

  add_index "people_work_experiences", ["user_id"], name: "index_people_work_experiences_on_user_id", using: :btree

  create_table "projects", force: :cascade do |t|
    t.string   "name",                  limit: 255,   default: "",    null: false
    t.text     "description",           limit: 65535
    t.string   "homepage",              limit: 255,   default: ""
    t.boolean  "is_public",                           default: true,  null: false
    t.integer  "parent_id",             limit: 4
    t.datetime "created_on"
    t.datetime "updated_on"
    t.string   "identifier",            limit: 255
    t.integer  "status",                limit: 4,     default: 1,     null: false
    t.integer  "lft",                   limit: 4
    t.integer  "rgt",                   limit: 4
    t.text     "dmsf_description",      limit: 65535
    t.boolean  "dmsf_notification",                   default: false
    t.boolean  "inherit_members",                     default: false, null: false
    t.string   "project_meeting_rooms", limit: 255
    t.integer  "default_version_id",    limit: 4
  end

  add_index "projects", ["lft"], name: "index_projects_on_lft", using: :btree
  add_index "projects", ["rgt"], name: "index_projects_on_rgt", using: :btree

  create_table "projects_trackers", id: false, force: :cascade do |t|
    t.integer "project_id", limit: 4, default: 0, null: false
    t.integer "tracker_id", limit: 4, default: 0, null: false
  end

  add_index "projects_trackers", ["project_id", "tracker_id"], name: "projects_trackers_unique", unique: true, using: :btree
  add_index "projects_trackers", ["project_id"], name: "projects_trackers_project_id", using: :btree

  create_table "queries", force: :cascade do |t|
    t.integer "project_id",    limit: 4
    t.string  "name",          limit: 255,   default: "", null: false
    t.text    "filters",       limit: 65535
    t.integer "user_id",       limit: 4,     default: 0,  null: false
    t.text    "column_names",  limit: 65535
    t.text    "sort_criteria", limit: 65535
    t.string  "group_by",      limit: 255
    t.string  "type",          limit: 255
    t.integer "visibility",    limit: 4,     default: 0
    t.text    "options",       limit: 65535
  end

  add_index "queries", ["project_id"], name: "index_queries_on_project_id", using: :btree
  add_index "queries", ["user_id"], name: "index_queries_on_user_id", using: :btree

  create_table "queries_roles", id: false, force: :cascade do |t|
    t.integer "query_id", limit: 4, null: false
    t.integer "role_id",  limit: 4, null: false
  end

  add_index "queries_roles", ["query_id", "role_id"], name: "queries_roles_ids", unique: true, using: :btree

  create_table "release_notes", force: :cascade do |t|
    t.integer "issue_id", limit: 4
    t.text    "text",     limit: 65535, null: false
  end

  add_index "release_notes", ["issue_id"], name: "index_release_notes_on_issue_id", using: :btree

  create_table "release_notes_formats", force: :cascade do |t|
    t.string "name",       limit: 255, null: false
    t.string "header",     limit: 255, null: false
    t.string "each_issue", limit: 255, null: false
    t.string "start",      limit: 255, null: false
    t.string "end",        limit: 255, null: false
  end

  add_index "release_notes_formats", ["name"], name: "index_release_notes_formats_on_name", unique: true, using: :btree

  create_table "repositories", force: :cascade do |t|
    t.integer  "project_id",    limit: 4,     default: 0,     null: false
    t.string   "url",           limit: 255,   default: "",    null: false
    t.string   "login",         limit: 60,    default: ""
    t.string   "password",      limit: 255,   default: ""
    t.string   "root_url",      limit: 255,   default: ""
    t.string   "type",          limit: 255
    t.string   "path_encoding", limit: 64
    t.string   "log_encoding",  limit: 64
    t.text     "extra_info",    limit: 65535
    t.string   "identifier",    limit: 255
    t.boolean  "is_default",                  default: false
    t.datetime "created_on"
  end

  add_index "repositories", ["project_id"], name: "index_repositories_on_project_id", using: :btree

  create_table "rich_rich_files", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "rich_file_file_name",    limit: 255
    t.string   "rich_file_content_type", limit: 255
    t.integer  "rich_file_file_size",    limit: 4
    t.datetime "rich_file_updated_at"
    t.string   "owner_type",             limit: 255
    t.integer  "owner_id",               limit: 4
    t.text     "uri_cache",              limit: 65535
    t.string   "simplified_type",        limit: 255,   default: "file"
  end

  create_table "roles", force: :cascade do |t|
    t.string  "name",                    limit: 30,    default: "",        null: false
    t.integer "position",                limit: 4
    t.boolean "assignable",                            default: true
    t.integer "builtin",                 limit: 4,     default: 0,         null: false
    t.text    "permissions",             limit: 65535
    t.string  "issues_visibility",       limit: 30,    default: "default", null: false
    t.string  "users_visibility",        limit: 30,    default: "all",     null: false
    t.string  "time_entries_visibility", limit: 30,    default: "all",     null: false
    t.boolean "all_roles_managed",                     default: true,      null: false
    t.text    "settings",                limit: 65535
  end

  create_table "roles_managed_roles", id: false, force: :cascade do |t|
    t.integer "role_id",         limit: 4, null: false
    t.integer "managed_role_id", limit: 4, null: false
  end

  add_index "roles_managed_roles", ["role_id", "managed_role_id"], name: "index_roles_managed_roles_on_role_id_and_managed_role_id", unique: true, using: :btree

  create_table "settings", force: :cascade do |t|
    t.string   "name",       limit: 255,   default: "", null: false
    t.text     "value",      limit: 65535
    t.datetime "updated_on"
  end

  add_index "settings", ["name"], name: "index_settings_on_name", using: :btree

  create_table "spent_time_queries", force: :cascade do |t|
    t.string  "name",      limit: 255
    t.string  "query",     limit: 500
    t.boolean "is_public"
    t.integer "user_id",   limit: 4
  end

  create_table "spm_databases", primary_key: "Id", force: :cascade do |t|
    t.string   "Name",         limit: 100, null: false
    t.string   "Description",  limit: 100
    t.integer  "ServerId",     limit: 4
    t.string   "UserID",       limit: 100, null: false
    t.string   "Password",     limit: 300, null: false
    t.datetime "ModifiedDate"
    t.integer  "ModifiedBy",   limit: 4
    t.binary   "IsDeleted",    limit: 1
  end

  create_table "spm_favorities_issues", primary_key: "Id", force: :cascade do |t|
    t.integer "IssueId", limit: 4,  null: false
    t.string  "UserId",  limit: 45, null: false
  end

  add_index "spm_favorities_issues", ["UserId", "IssueId"], name: "IssueId_UserId", using: :btree

  create_table "spm_log_action", primary_key: "Id", force: :cascade do |t|
    t.string  "ActionName",   limit: 50
    t.integer "ActionTypeId", limit: 4
    t.string  "SpName",       limit: 50
    t.text    "Items",        limit: 65535
    t.text    "SubItems",     limit: 65535
  end

  create_table "spm_log_action_type", primary_key: "Id", force: :cascade do |t|
    t.string "Name", limit: 250
  end

  create_table "spm_log_details", primary_key: "Id", force: :cascade do |t|
    t.integer  "UserId",       limit: 4
    t.string   "SpName",       limit: 50
    t.datetime "LogDate"
    t.integer  "ObjectId",     limit: 4
    t.integer  "ObjectTypeId", limit: 4
    t.integer  "ActionId",     limit: 4
    t.text     "Data",         limit: 65535
    t.text     "OldData",      limit: 65535
  end

  create_table "spm_servers", primary_key: "Id", force: :cascade do |t|
    t.string   "Name",         limit: 100, null: false
    t.string   "IPLocal",      limit: 50
    t.string   "IPUAT",        limit: 50
    t.string   "IPProduction", limit: 50
    t.string   "Description",  limit: 100
    t.datetime "ModifiedDate"
    t.integer  "ModifiedBy",   limit: 4
    t.binary   "IsDeleted",    limit: 1
  end

  create_table "spm_storedprocedure_issues", primary_key: "Id", force: :cascade do |t|
    t.binary   "IsFunction",        limit: 1,   default: "b'0'", null: false
    t.string   "ActionName",        limit: 10
    t.integer  "ModifiedBy",        limit: 4,                    null: false
    t.integer  "Status",            limit: 4,                    null: false
    t.string   "Description",       limit: 300,                  null: false
    t.integer  "IssueId",           limit: 4,                    null: false
    t.datetime "ModifiedDate"
    t.integer  "DeveloperId",       limit: 4,                    null: false
    t.binary   "IsDeleted",         limit: 1
    t.integer  "StoredProcedureId", limit: 4
  end

  add_index "spm_storedprocedure_issues", ["IssueId"], name: "IssueId", using: :btree

  create_table "spm_storedprocedures", primary_key: "Id", force: :cascade do |t|
    t.integer "ServerId",   limit: 4
    t.integer "DatabaseId", limit: 4
    t.string  "Name",       limit: 300
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id",        limit: 4
    t.integer  "taggable_id",   limit: 4
    t.string   "taggable_type", limit: 255
    t.integer  "tagger_id",     limit: 4
    t.string   "tagger_type",   limit: 255
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "time_entries", force: :cascade do |t|
    t.integer  "project_id",  limit: 4,    null: false
    t.integer  "user_id",     limit: 4,    null: false
    t.integer  "issue_id",    limit: 4
    t.float    "hours",       limit: 24,   null: false
    t.string   "comments",    limit: 1024
    t.integer  "activity_id", limit: 4,    null: false
    t.date     "spent_on",                 null: false
    t.integer  "tyear",       limit: 4,    null: false
    t.integer  "tmonth",      limit: 4,    null: false
    t.integer  "tweek",       limit: 4,    null: false
    t.datetime "created_on",               null: false
    t.datetime "updated_on",               null: false
    t.integer  "meeting_id",  limit: 4
  end

  add_index "time_entries", ["activity_id"], name: "index_time_entries_on_activity_id", using: :btree
  add_index "time_entries", ["created_on"], name: "index_time_entries_on_created_on", using: :btree
  add_index "time_entries", ["issue_id"], name: "time_entries_issue_id", using: :btree
  add_index "time_entries", ["meeting_id"], name: "index_time_entries_on_meeting_id", using: :btree
  add_index "time_entries", ["project_id"], name: "time_entries_project_id", using: :btree
  add_index "time_entries", ["user_id"], name: "index_time_entries_on_user_id", using: :btree

  create_table "tokens", force: :cascade do |t|
    t.integer  "user_id",    limit: 4,  default: 0,  null: false
    t.string   "action",     limit: 30, default: "", null: false
    t.string   "value",      limit: 40, default: "", null: false
    t.datetime "created_on",                         null: false
    t.datetime "updated_on"
  end

  add_index "tokens", ["user_id"], name: "index_tokens_on_user_id", using: :btree
  add_index "tokens", ["value"], name: "tokens_value", unique: true, using: :btree

  create_table "trackers", force: :cascade do |t|
    t.string  "name",              limit: 30, default: "",    null: false
    t.boolean "is_in_chlog",                  default: false, null: false
    t.integer "position",          limit: 4
    t.boolean "is_in_roadmap",                default: true,  null: false
    t.integer "fields_bits",       limit: 4,  default: 0
    t.integer "default_status_id", limit: 4
  end

  create_table "user_list_settings", force: :cascade do |t|
    t.integer "user_id", limit: 4,     null: false
    t.string  "list",    limit: 30,    null: false
    t.text    "columns", limit: 65535
  end

  add_index "user_list_settings", ["user_id", "list"], name: "settings_list_user_ids", unique: true, using: :btree

  create_table "user_preferences", force: :cascade do |t|
    t.integer "user_id",              limit: 4,     default: 0,    null: false
    t.text    "others",               limit: 65535
    t.boolean "hide_mail",                          default: true
    t.string  "time_zone",            limit: 255
    t.integer "favourite_project_id", limit: 4
  end

  add_index "user_preferences", ["user_id"], name: "index_user_preferences_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "login",              limit: 255, default: "",    null: false
    t.string   "hashed_password",    limit: 40,  default: "",    null: false
    t.string   "firstname",          limit: 30,  default: "",    null: false
    t.string   "lastname",           limit: 255, default: "",    null: false
    t.boolean  "admin",                          default: false, null: false
    t.integer  "status",             limit: 4,   default: 1,     null: false
    t.datetime "last_login_on"
    t.string   "language",           limit: 5,   default: ""
    t.integer  "auth_source_id",     limit: 4
    t.datetime "created_on"
    t.datetime "updated_on"
    t.string   "type",               limit: 255
    t.string   "identity_url",       limit: 255
    t.string   "mail_notification",  limit: 255, default: "",    null: false
    t.string   "salt",               limit: 64
    t.boolean  "must_change_passwd",             default: false, null: false
    t.datetime "passwd_changed_on"
  end

  add_index "users", ["auth_source_id"], name: "index_users_on_auth_source_id", using: :btree
  add_index "users", ["id", "type"], name: "index_users_on_id_and_type", using: :btree
  add_index "users", ["type"], name: "index_users_on_type", using: :btree

  create_table "versions", force: :cascade do |t|
    t.integer  "project_id",      limit: 4,   default: 0,      null: false
    t.string   "name",            limit: 255, default: "",     null: false
    t.string   "description",     limit: 255, default: ""
    t.date     "effective_date"
    t.datetime "created_on"
    t.datetime "updated_on"
    t.string   "wiki_page_title", limit: 255
    t.string   "status",          limit: 255, default: "open"
    t.string   "sharing",         limit: 255, default: "none", null: false
  end

  add_index "versions", ["project_id"], name: "versions_project_id", using: :btree
  add_index "versions", ["sharing"], name: "index_versions_on_sharing", using: :btree

  create_table "viewings", force: :cascade do |t|
    t.integer  "viewer_id",   limit: 4
    t.integer  "viewed_id",   limit: 4
    t.string   "viewed_type", limit: 255
    t.string   "ip",          limit: 24
    t.datetime "created_at"
  end

  add_index "viewings", ["viewed_type", "viewed_id"], name: "index_viewings_on_viewed_type_and_viewed_id", using: :btree
  add_index "viewings", ["viewer_id"], name: "index_viewings_on_viewer_id", using: :btree

  create_table "votes", force: :cascade do |t|
    t.integer  "votable_id",   limit: 4
    t.string   "votable_type", limit: 255
    t.integer  "voter_id",     limit: 4
    t.string   "voter_type",   limit: 255
    t.boolean  "vote_flag"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "votes", ["votable_id", "votable_type"], name: "index_votes_on_votable_id_and_votable_type", using: :btree
  add_index "votes", ["voter_id", "voter_type"], name: "index_votes_on_voter_id_and_voter_type", using: :btree

  create_table "watchers", force: :cascade do |t|
    t.string  "watchable_type", limit: 255, default: "", null: false
    t.integer "watchable_id",   limit: 4,   default: 0,  null: false
    t.integer "user_id",        limit: 4
  end

  add_index "watchers", ["user_id", "watchable_type"], name: "watchers_user_id_type", using: :btree
  add_index "watchers", ["user_id"], name: "index_watchers_on_user_id", using: :btree
  add_index "watchers", ["watchable_id", "watchable_type"], name: "index_watchers_on_watchable_id_and_watchable_type", using: :btree

  create_table "wiki_content_versions", force: :cascade do |t|
    t.integer  "wiki_content_id", limit: 4,                       null: false
    t.integer  "page_id",         limit: 4,                       null: false
    t.integer  "author_id",       limit: 4
    t.binary   "data",            limit: 4294967295
    t.string   "compression",     limit: 6,          default: ""
    t.string   "comments",        limit: 1024,       default: ""
    t.datetime "updated_on",                                      null: false
    t.integer  "version",         limit: 4,                       null: false
  end

  add_index "wiki_content_versions", ["updated_on"], name: "index_wiki_content_versions_on_updated_on", using: :btree
  add_index "wiki_content_versions", ["wiki_content_id"], name: "wiki_content_versions_wcid", using: :btree

  create_table "wiki_contents", force: :cascade do |t|
    t.integer  "page_id",    limit: 4,                       null: false
    t.integer  "author_id",  limit: 4
    t.text     "text",       limit: 4294967295
    t.string   "comments",   limit: 1024,       default: ""
    t.datetime "updated_on",                                 null: false
    t.integer  "version",    limit: 4,                       null: false
  end

  add_index "wiki_contents", ["author_id"], name: "index_wiki_contents_on_author_id", using: :btree
  add_index "wiki_contents", ["page_id"], name: "wiki_contents_page_id", using: :btree

  create_table "wiki_pages", force: :cascade do |t|
    t.integer  "wiki_id",    limit: 4,                   null: false
    t.string   "title",      limit: 255,                 null: false
    t.datetime "created_on",                             null: false
    t.boolean  "protected",              default: false, null: false
    t.integer  "parent_id",  limit: 4
  end

  add_index "wiki_pages", ["parent_id"], name: "index_wiki_pages_on_parent_id", using: :btree
  add_index "wiki_pages", ["wiki_id", "title"], name: "wiki_pages_wiki_id_title", using: :btree
  add_index "wiki_pages", ["wiki_id"], name: "index_wiki_pages_on_wiki_id", using: :btree

  create_table "wiki_redirects", force: :cascade do |t|
    t.integer  "wiki_id",              limit: 4,   null: false
    t.string   "title",                limit: 255
    t.string   "redirects_to",         limit: 255
    t.datetime "created_on",                       null: false
    t.integer  "redirects_to_wiki_id", limit: 4,   null: false
  end

  add_index "wiki_redirects", ["wiki_id", "title"], name: "wiki_redirects_wiki_id_title", using: :btree
  add_index "wiki_redirects", ["wiki_id"], name: "index_wiki_redirects_on_wiki_id", using: :btree

  create_table "wikis", force: :cascade do |t|
    t.integer "project_id", limit: 4,               null: false
    t.string  "start_page", limit: 255,             null: false
    t.integer "status",     limit: 4,   default: 1, null: false
  end

  add_index "wikis", ["project_id"], name: "wikis_project_id", using: :btree

  create_table "workflows", force: :cascade do |t|
    t.integer "tracker_id",    limit: 4,  default: 0,     null: false
    t.integer "old_status_id", limit: 4,  default: 0,     null: false
    t.integer "new_status_id", limit: 4,  default: 0,     null: false
    t.integer "role_id",       limit: 4,  default: 0,     null: false
    t.boolean "assignee",                 default: false, null: false
    t.boolean "author",                   default: false, null: false
    t.string  "type",          limit: 30
    t.string  "field_name",    limit: 30
    t.string  "rule",          limit: 30
  end

  add_index "workflows", ["new_status_id"], name: "index_workflows_on_new_status_id", using: :btree
  add_index "workflows", ["old_status_id"], name: "index_workflows_on_old_status_id", using: :btree
  add_index "workflows", ["role_id", "tracker_id", "old_status_id"], name: "wkfs_role_tracker_old_status", using: :btree
  add_index "workflows", ["role_id"], name: "index_workflows_on_role_id", using: :btree

end
