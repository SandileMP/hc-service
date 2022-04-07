FROM mcr.microsoft.com/dotnet/aspnet:5.0-focal AS base
WORKDIR /app
EXPOSE 80
FROM mcr.microsoft.com/dotnet/sdk:5.0-focal AS build
WORKDIR /src
COPY ["CICDDemo.csproj", "./"]
RUN dotnet restore "./CICDDemo.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "CICDDemo.csproj" -c Release -o /app/build
FROM build AS publish
RUN dotnet publish "CICDDemo.csproj" -c Release -o /app/publish
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "CICDDemo.dll"]