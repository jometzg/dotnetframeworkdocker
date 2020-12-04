FROM mcr.microsoft.com/dotnet/framework/sdk:4.8 AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.sln .
COPY TestFrameworkApp/*.csproj ./TestFrameworkApp/
COPY TestFrameworkApp/*.config ./TestFrameworkApp/
COPY TestFrameworkApp/. ./TestFrameworkApp/
RUN nuget restore

#CMD [ "cmd" ]

# copy everything else and build app
#COPY aspnetapp/. ./aspnetapp/
WORKDIR /app/TestFrameworkApp
RUN msbuild /p:Configuration=Release


FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8 AS runtime
WORKDIR /inetpub/wwwroot
COPY --from=build /app/TestFrameworkApp/. ./