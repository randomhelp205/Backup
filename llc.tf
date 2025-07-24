# main.tf

# Define a local variable for the LCC script content
# This reads the content of the backup.sh file and base64 encodes it.
# IMPORTANT: Ensure you have a file named 'backup.sh' in the same directory as this main.tf
# and that it contains the corrected backup script (with rsync installation).
locals {
  lifecycle_config_script_content = filebase64("${path.module}/backup.sh")
}

# Resource to create the SageMaker Studio Lifecycle Configuration
resource "aws_sagemaker_studio_lifecycle_config" "ebs_efs_backup_lcc" {
  # Name for your Lifecycle Configuration
  # It's good practice to make this descriptive.
  name = "ebs-efs-backup-lcc"

  # The base64-encoded content of your shell script.
  # This will be the backup.sh script.
  content = local.lifecycle_config_script_content

  # The type of application this lifecycle configuration applies to.
  # For JupyterLab, use "JupyterLab".
  studio_lifecycle_config_app_type = "JupyterLab"

  # Optional: Add tags for better resource management and cost allocation
  tags = {
    Project     = "SageMakerDR"
    Environment = "Dev"
    Purpose     = "EBSBackup"
  }
}

# Output the ARN of the created Lifecycle Configuration
# This can be useful for referencing it in other parts of your Terraform configuration,
# for example, when attaching it to a SageMaker User Profile.
output "lifecycle_config_arn" {
  description = "The ARN of the SageMaker Studio Lifecycle Configuration."
  value       = aws_sagemaker_studio_lifecycle_config.ebs_efs_backup_lcc.arn
}
