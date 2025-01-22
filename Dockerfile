# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /app

# Copy only the project file(s) first for better caching
COPY *.csproj ./
RUN dotnet restore

# Copy the remaining source code
COPY . ./
RUN dotnet publish -c Release -o /out

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:9.0
WORKDIR /app
COPY --from=build /out .

# Expose port 80
EXPOSE 80

# Set environment variables
ENV ASPNETCORE_URLS=http://+:80

# Define the entry point
ENTRYPOINT ["dotnet", "Dockerapi.dll"]