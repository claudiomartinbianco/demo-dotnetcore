FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /src
COPY ["demo-dotnetcore.csproj", "./"]
RUN dotnet restore "demo-dotnetcore.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "demo-dotnetcore.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "demo-dotnetcore.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "demo-dotnetcore.dll"]
