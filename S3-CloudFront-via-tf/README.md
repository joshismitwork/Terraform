# 🚀 Secure Static Website Hosting via AWS S3 & CloudFront

A production-grade, highly available, and secure static website deployment architecture automated entirely with **Terraform**. This project provisions a globally optimized content delivery network (CDN) leveraging AWS best practices for performance, caching, and modern security compliance.

## 🏗️ Architecture Overview

[ User Browser ]
│
▼
(HTTPS Request)[ Route 53 ] ──► Translates Domain Name
│
▼
[ CloudFront CDN ] ◄── [ ACM ] Provides SSL/TLS Certificates (us-east-1)
│
▼
(Origin Access Control - OAC)[ S3 Bucket ] ──► Stores Private Static Assets (index.html, error.html)

### Key Architectural Features:
* **Enhanced Security (OAC):** The S3 bucket blocks all public access. CloudFront uses **Origin Access Control (OAC)** to securely fetch assets, ensuring users cannot bypass the CDN.
* **Global Performance:** Integrated with Amazon CloudFront edge locations to provide low-latency asset delivery and high transfer speeds worldwide.
* **Automated SSL/TLS:** Provisioned via AWS Certificate Manager (ACM) in `us-east-1` for full end-to-end `https://` transit encryption.
* **Intelligent Routing:** Configured with Route 53 using latency/alias records to route custom domain traffic seamlessly.

---

## 🛠️ Technology Stack

* **Infrastructure as Code:** Terraform (>= 1.0.0)
* **Cloud Provider:** Amazon Web Services (AWS)
* **Core Services:** S3, CloudFront, Route 53, ACM

---

## 📂 Repository Structure

```text
├── S3-CloudFront-via-tf/
│   ├── main.tf          # Core infrastructure declarations (S3, CloudFront, ACM, Route 53)
│   ├── variables.tf     # Configurable input variables (domains, bucket names)
│   ├── outputs.tf       # Resulting endpoints and distribution IDs
│   ├── index.html       # Main website landing page
│   └── error.html       # Custom 404 error routing page
└── README.md            # Project documentation
```

---

## 🚀 Deployment & Usage

### 1. Prerequisites
* [Terraform](https://terraform.io) installed locally.
* [AWS CLI](https://amazon.com) configured with appropriate IAM deployment permissions.
* A registered domain managed inside an Amazon Route 53 Hosted Zone.

### 2. Initialization & Execution
Navigate to your project directory and run the following sequential Git and Terraform commands:

```powershell
# Initialize Terraform providers and download state modules
terraform init

# Review the execution plan to verify in-place modifications
terraform plan

# Deploy the infrastructure securely to AWS
terraform apply --auto-approve
```

### 3. Handling CloudFront Cache Invalidations
When you modify your `index.html` or `error.html` locally and upload updates to S3, run an invalidation to clear the edge location caches instantly:

```powershell
# Trigger a manual cache purge via AWS CLI
aws cloudfront create-invalidation --distribution-id YOUR_DIST_ID --paths "/*"
```

---

## 🔒 Security Best Practices Implemented

1. **Principle of Least Privilege:** S3 bucket policies explicitly restrict access *only* to the CloudFront distribution identity.
2. **Enforced HTTPS:** CloudFront is configured to automatically redirect all legacy HTTP traffic (`port 80`) to secure HTTPS (`port 443`).
3. **Dedicated ACM Region:** Enforces strict adherence to CloudFront architecture by generating SSL components solely inside `us-east-1`.

---

## 👤 Author

* **GitHub:** [@joshismitwork](https://github.com)
* **Project Name:** Terraform Infrastructure Automations
