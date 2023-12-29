using Microsoft.EntityFrameworkCore;

namespace Inventroy_backEnd.Data
{
    public class AppDbContext:DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options):base(options)
        {
            
        }
        
    }
}