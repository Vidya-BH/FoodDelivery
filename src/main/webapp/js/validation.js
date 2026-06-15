// Interactive Form Validations

document.addEventListener('DOMContentLoaded', function() {
    // 1. Signup / Register Form Validation
    const registerForm = document.querySelector('form[action*="register"]');
    if (registerForm) {
        registerForm.addEventListener('submit', function(event) {
            let isValid = true;
            
            const usernameInput = registerForm.querySelector('input[name="username"]');
            const passwordInput = registerForm.querySelector('input[name="password"]');
            const emailInput = registerForm.querySelector('input[name="email"]');
            const phoneInput = registerForm.querySelector('input[name="phone"]');
            const addressInput = registerForm.querySelector('textarea[name="address"]');

            // Reset custom error borders
            [usernameInput, passwordInput, emailInput, phoneInput, addressInput].forEach(inp => {
                if (inp) inp.classList.remove('is-invalid');
            });

            // Username validation
            if (usernameInput && usernameInput.value.trim().length < 4) {
                showFieldValidationError(usernameInput, 'Username must be at least 4 characters long.');
                isValid = false;
            }

            // Password validation
            if (passwordInput && passwordInput.value.length < 6) {
                showFieldValidationError(passwordInput, 'Password must be at least 6 characters long.');
                isValid = false;
            }

            // Email validation
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (emailInput && !emailRegex.test(emailInput.value.trim())) {
                showFieldValidationError(emailInput, 'Please enter a valid email address.');
                isValid = false;
            }

            // Phone validation
            const phoneRegex = /^\d{10}$/;
            if (phoneInput && !phoneRegex.test(phoneInput.value.trim())) {
                showFieldValidationError(phoneInput, 'Please enter a valid 10-digit phone number.');
                isValid = false;
            }

            // Address validation
            if (addressInput && addressInput.value.trim().length < 10) {
                showFieldValidationError(addressInput, 'Please enter a detailed delivery address (min 10 characters).');
                isValid = false;
            }

            if (!isValid) {
                event.preventDefault();
            }
        });
    }

    // 2. Checkout Form Validation
    const checkoutForm = document.querySelector('form[action*="checkout"]');
    if (checkoutForm) {
        checkoutForm.addEventListener('submit', function(event) {
            let isValid = true;
            const addressInput = checkoutForm.querySelector('textarea[name="deliveryAddress"]');

            if (addressInput) {
                addressInput.classList.remove('is-invalid');
                if (addressInput.value.trim().length < 10) {
                    showFieldValidationError(addressInput, 'Please enter a full, detailed delivery address.');
                    isValid = false;
                }
            }

            if (!isValid) {
                event.preventDefault();
            }
        });
    }
});

function showFieldValidationError(element, message) {
    element.classList.add('is-invalid');
    let feedback = element.parentNode.querySelector('.invalid-feedback');
    if (!feedback) {
        feedback = document.createElement('div');
        feedback.className = 'invalid-feedback';
        element.parentNode.appendChild(feedback);
    }
    feedback.innerText = message;
    
    // Auto-scroll to first invalid element
    element.scrollIntoView({ behavior: 'smooth', block: 'center' });
}
