# dotnet framework docker
This repository demonstrates how to containerise a .NET framework web application.

## The application
This is a demo application that is created in Visual Studio 2019 when adding a .NET framework application

## Dockerfile
This dockerfile is an adaption of a standard one https://github.com/microsoft/dotnet-framework-docker/blob/master/samples/aspnetapp/Dockerfile

![VS2019 wizard](/wizard.png)

Note in the example, the solution name is "TestFrameworkApp" and this in Visual Studio created a *TestFrameworkApp.sln* file and the rest of the project and its *TestFrameworkApp.csproj* under that folder. This Dockerfile references these paths.
```
# in a development container
FROM mcr.microsoft.com/dotnet/framework/sdk:4.8 AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.sln .
COPY TestFrameworkApp/*.csproj ./TestFrameworkApp/
COPY TestFrameworkApp/*.config ./TestFrameworkApp/
COPY TestFrameworkApp/. ./TestFrameworkApp/
RUN nuget restore

# to debug this part
#CMD [ "cmd" ]

# build and publish release version
WORKDIR /app/TestFrameworkApp
RUN msbuild /p:Configuration=Release

# in runtime container
FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8 AS runtime
WORKDIR /inetpub/wwwroot
COPY --from=build /app/TestFrameworkApp/. ./
```

It is also useful to note that the Dockerfile is in two parts:
1. A development container that is built on a base image with development tools. This builds and publishes a release version of the application.
2. A runtime container that does not have development tools. This runs the published app

## Running the dockerfile

This is done in the usual manner:
```
docker run -it -p 8080:80 testfw
```
where *testfw* is the image name.

![Running app](/frontpage.png)
