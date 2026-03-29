resource "aws_s3_bucket" "practice_lab" {
  bucket_prefix = "jenkins-bucket-"
  force_destroy = true
  

  tags = {
    Name = "Jenkins Bucket"
  }
}

##############################################################################################

resource "aws_s3_bucket_public_access_block" "practice_lab" {
  bucket = aws_s3_bucket.practice_lab.id

  block_public_acls       = true
  ignore_public_acls      = true

  block_public_policy     = false
  restrict_public_buckets = false
}


resource "aws_s3_bucket_policy" "public_access" {
  bucket = aws_s3_bucket.practice_lab.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "Potato"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.practice_lab.arn}/*"
      }
    ]
  })
   # add this explict dependency, dependency chain issues occur intermittenly 
  depends_on = [ aws_s3_bucket_public_access_block.practice_lab ]
}


resource "aws_s3_object" "object_upload" {
  for_each = fileset("${path.module}/jenkins-s3-test/lab_deliverables", "**/*.*")
  
  bucket = aws_s3_bucket.practice_lab.id
  key    = each.value # The object key in S3 will be the file name and path relative to app_files/
  source = "${path.module}/jenkins-s3-test/lab_deliverables/${each.value}" # The local file path

  # Automatically calculate the ETag as an MD5 hash of the file content
  etag = filemd5("${path.module}/jenkins-s3-test/lab_deliverables/${each.value}") 
}


// test updated

//test-1-2-3-4-5-6

