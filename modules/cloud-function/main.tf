# Generates an archive of the source code compressed as a .zip file.
# data "archive_file" "source" {
#   type = "zip"
#   source_dir  = "${path.module}/hello-function/src"
#   output_path = "/tmp/function.zip"
# }


# locals {
#   function_name         = "hello_funtion"
#   function_runtime      = "python37"
#   function_bucket_store = "mc-function-store"
# }
#login cloud function
data "archive_file" "source" {
  type        = "zip"
  source_dir  = "${path.module}/vriddhi/login/src"
  output_path = "/tmp/function.zip"
}


locals {
  function_name         = "login_funtion"
  function_runtime      = "python37"
  function_bucket_store = "mc-function-store"
}

# Add source code zip to the Cloud Function's bucket
resource "google_storage_bucket_object" "zip" {
  source       = data.archive_file.source.output_path
  content_type = "application/zip"

  # Append to the MD5 checksum of the files's content
  # to force the zip to be updated as soon as a change occurs
  name   = "src-${data.archive_file.source.output_md5}.zip"
  bucket = local.function_bucket_store

}

# Create the Cloud function triggered by a `Finalize` event on the bucket
resource "google_cloudfunctions_function" "function" {
  name    = local.function_name
  runtime = local.function_runtime # of course changeable

  # Get the source code of the cloud function as a Zip compression
  #source_archive_bucket = google_storage_bucket.function_bucket.name
  source_archive_bucket = local.function_bucket_store
  source_archive_object = google_storage_bucket_object.zip.name

  # Must match the function name in the cloud function `main.py` source code
  entry_point = "hello_get"

  available_memory_mb = 128
  trigger_http        = true

  environment_variables = {
    PROJECT_ID = var.gcp_project
  }
}



# IAM entry for all users to invoke the function
resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = google_cloudfunctions_function.function.project
  region         = google_cloudfunctions_function.function.region
  cloud_function = google_cloudfunctions_function.function.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}
