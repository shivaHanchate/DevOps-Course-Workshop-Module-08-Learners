FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build

# Using Ubuntu
RUN apt-get update -y
RUN apt-get install curl gnupg -y
RUN curl -fsSL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs

WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.sln .
COPY DotnetTemplate.Web/*.csproj ./DotnetTemplate.Web/
COPY DotnetTemplate.Web.Tests/*.csproj ./DotnetTemplate.Web.Tests/
RUN dotnet restore

# copy and publish app and libraries
COPY DotnetTemplate.Web/. ./DotnetTemplate.Web/
RUN dotnet build
WORKDIR /app/DotnetTemplate.Web
RUN npm install 
RUN npm run build

ENTRYPOINT ["dotnet","run"]