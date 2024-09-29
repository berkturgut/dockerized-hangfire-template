using Hangfire;
using Hangfire.Dashboard;
using Microsoft.Data.SqlClient;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
// Hangfire MSSQL yapılandırması
builder.Services.AddHangfire(configuration => configuration
    //.UseSqlServerStorage("Server=localhost,1437;Database=task-manager;User Id=sa;Password=yourStrong(!)Password;TrustServerCertificate=True;")); //Lokalden - Docker db'ye bağlantı
    .UseSqlServerStorage("Server=mssql-container,1433;Database=task-manager;User Id=sa;Password=YourStrong(!)Password;TrustServerCertificate=True;")
);
    
// Hangfire server'ı başlat
builder.Services.AddHangfireServer();

builder.WebHost.ConfigureKestrel(options =>
{
    options.ListenAnyIP(8080); // Tüm IP'lerden gelen istekleri dinle
});

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();


// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}



// Hangfire Dashboard'ı etkinleştir
app.UseHangfireDashboard("/hangfire", new DashboardOptions
{
    Authorization = new[] { new AllowAllDashboardAuthorizationFilter() }
});

app.UseAuthorization();

app.MapControllers();

app.Run();



public class AllowAllDashboardAuthorizationFilter : IDashboardAuthorizationFilter
{
    public bool Authorize(DashboardContext context)
    {
        return true; // Herkese izin ver
    }
}

