using System.ComponentModel.DataAnnotations;
using Inventroy_backEnd.Data;
using Inventroy_backEnd.Models.ViewModels;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;


namespace Inventroy_backEnd.Services
{
    public class AccountServices
    {
        private readonly UserManager<IdentityUser> _userManager;
        private readonly SignInManager<IdentityUser> _signInManager;

        private readonly AppDBContext _context;


        public AccountServices(UserManager<IdentityUser> userManager,
                              SignInManager<IdentityUser> signInManager,AppDBContext context)
    {
            _userManager = userManager;
            _signInManager = signInManager;
            _context = context;
    }



        public async Task<Microsoft.AspNetCore.Identity.SignInResult> Login(LoginVM user)
        {
           
               var result = await _signInManager.PasswordSignInAsync(user.Email, user.Password, user.RememberMe, false);

            return result;
      }



        public async Task<Microsoft.AspNetCore.Identity.IdentityResult> Register(RegisterVM model)
        {
            
         
                var user = new IdentityUser
                {
                    UserName = model.Email,
                    Email = model.Email,
                };

                var result = await _userManager.CreateAsync(user, model.Password);

            System.Console.Write("The error is : {0} ", result);

                if (result.Succeeded)
                {
                    
                    await _signInManager.SignInAsync(user, isPersistent: false);

                }

                  return result;


           
        }


    }


}