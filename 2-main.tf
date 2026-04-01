
resource "aws_s3_bucket" "insecure_bucket" {
  bucket = "insecure-demo-bucket"
}

resource "aws_s3_bucket_public_access_block" "insecure_bucket" {
  bucket = aws_s3_bucket.insecure_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_security_group" "wide_open" {
  name = "wide-open-sg"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_policy" "wildcard_policy" {
  name = "wildcard-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "*"
      Resource = "*"
    }]
  })
}

resource "aws_instance" "no_imdsv2" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  metadata_options {
    http_tokens = "optional"
  }
}

















# resource "aws_s3_bucket" "practice_lab" {
#   bucket_prefix = "jenkins-bucket-"
#   force_destroy = true
  

#   tags = {
#     Name = "Jenkins Bucket"
#   }
# }

# ##############################################################################################

# resource "aws_s3_bucket_public_access_block" "practice_lab" {
#   bucket = aws_s3_bucket.practice_lab.id

#   block_public_acls       = true
#   ignore_public_acls      = true

#   block_public_policy     = false
#   restrict_public_buckets = false
# }


# resource "aws_s3_bucket_policy" "public_access" {
#   bucket = aws_s3_bucket.practice_lab.id
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid       = "Potato"
#         Effect    = "Allow"
#         Principal = "*"
#         Action    = "s3:GetObject"
#         Resource  = "${aws_s3_bucket.practice_lab.arn}/*"
#       }
#     ]
#   })
#    # add this explict dependency, dependency chain issues occur intermittenly 
#   depends_on = [ aws_s3_bucket_public_access_block.practice_lab ]
# }


# resource "aws_s3_object" "image" {
#   bucket = aws_s3_bucket.practice_lab.bucket
#   key    = "Image_1.png"
#   source = "./lab_deliverables/Image_1.png"
#   content_type = "image/png"

#   etag = filemd5("./lab_deliverables/Image_1.png")
# }

# resource "aws_s3_object" "image2" {
#   bucket = aws_s3_bucket.practice_lab.bucket
#   key    = "Image_2.png"
#   source = "./lab_deliverables/Image_2.png"
#   content_type = "image/png"

#   etag = filemd5("./lab_deliverables/Image_2.png")
# }

# resource "aws_s3_object" "image3" {
#   bucket = aws_s3_bucket.practice_lab.bucket
#   key    = "Image_3.png"
#   source = "./lab_deliverables/Image_3.png"
#   content_type = "image/png"

#   etag = filemd5("./lab_deliverables/Image_3.png")
# }

# resource "aws_s3_object" "text_deliverable" {
#   bucket = aws_s3_bucket.practice_lab.bucket
#   key    = "lab_deliverable.txt"
#   source = "./lab_deliverables/lab_deliverable.txt"
#   content_type = "text/text"

#   etag = filemd5("./lab_deliverables/lab_deliverable.txt")
# }

# resource "aws_s3_object" "image4" {
#   bucket = aws_s3_bucket.practice_lab.bucket
#   key    = "Image_4.png"
#   source = "./lab_deliverables/Image_4.png"
#   content_type = "image/png"

#   etag = filemd5("./lab_deliverables/Image_4.png")
# }

# resource "aws_s3_object" "image5" {
#   bucket = aws_s3_bucket.practice_lab.bucket
#   key    = "Image_5.png"
#   source = "./lab_deliverables/Image_5.png"
#   content_type = "image/png"

#   etag = filemd5("./lab_deliverables/Image_5.png")
# }



# // test updated

# //test-1-2-3-4-5-6

