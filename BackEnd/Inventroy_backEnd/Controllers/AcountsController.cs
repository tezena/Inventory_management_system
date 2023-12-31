using System.Reflection.Metadata.Ecma335;
using Inventroy_backEnd.Models.ViewModels;
using Inventroy_backEnd.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore.Metadata.Internal;

namespace Inventroy_backEnd.Controllers
{    
     [Route("api/[controller]")]
     [ApiController]
    public class AccountsController:ControllerBase
    {

        public AccountServices _accountServices;
        public AccountsController(AccountServices services)
        {
            _accountServices = services;
        }

        [HttpPost("Login")]
         [AllowAnonymous]
        public async Task<IActionResult> Login(LoginVM model)
        {
            if (ModelState.IsValid)
            {

                var result = await _accountServices.Login(model);

                if (result.Succeeded)
                {
                    return Ok();
                }

                ModelState.AddModelError(string.Empty, "Invalid Login Attempt");

                return Unauthorized(new { Error = new[] { "Invalid Login Attempt" } });

            }

          return BadRequest(new { Errors = ModelState.Values.SelectMany(v => v.Errors.Select(e => e.ErrorMessage)) });


        }

         [HttpPost("Register")]
        public async Task<IActionResult> Register(RegisterVM model)
        {
            if (ModelState.IsValid)
            {

                var result = await _accountServices.Register(model);

                if (result.Succeeded)
                {

                    return Ok();
                }

                ModelState.AddModelError(string.Empty, "Invalid Registration");

                var erroMessage = result.Errors.Select(error => error.Description);

                return BadRequest(new { Errors = erroMessage });


            }
            return BadRequest(new { Errors = ModelState.Values.SelectMany(v => v.Errors.Select(e => e.ErrorMessage)) });
        }
         
    }
}