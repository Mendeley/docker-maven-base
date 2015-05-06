# docker-maven-base

Shared base image of Maven, customised with Mendeley-specific and non-sensitive settings.

So that you don't have to copypasta all of those shared settings into your Docker child images. 

## Usage

In your application Dockerfile:

```
FROM mendeley/maven-base:latest

...
```