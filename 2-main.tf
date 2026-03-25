resource "aws_s3_bucket" "frontend" {
  bucket_prefix = "jenkins-bucket-"
  force_destroy = true
  

  tags = {
    Name = "Jenkins Bucket"
  }
}

<<<<<<< HEAD
// test updated
=======
//test
>>>>>>> refs/remotes/origin/main
