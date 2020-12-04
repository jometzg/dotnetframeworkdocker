# in a deverlopment container
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