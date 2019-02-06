FROM microsoft/dotnet:2.1-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /src
COPY ["BuildTest.csproj", ""]
RUN dotnet restore "BuildTest.csproj"
COPY . .
WORKDIR "/src/"
RUN dotnet build "BuildTest.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "BuildTest.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "BuildTest.dll"]
