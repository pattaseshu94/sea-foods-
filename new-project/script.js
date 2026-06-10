const products = [
  {
    id: "king-fish",
    name: "Tuna Fish",
    category: "fish",
    price: 680,
    unit: "kg",
    image: "assets/tuna.jpg",
    tag: "Best seller",
    description: "Firm, clean slices for fry, curry, or grill orders."
  },
  {
    id: "pomfret",
    name: "King Fish",
    category: "fish",
    price: 760,
    unit: "kg",
    image: "assets/king fish.jpg",
    tag: "Fresh catch",
    description: "Soft, mild fish for fry, steam, and special family meals."
  },
  {
    id: "seer-fish",
    name: "White Pomfret",
    category: "fish",
    price: 720,
    unit: "kg",
    image: "assets/white promfet.jpg",
    tag: "Cut pieces",
    description: "Popular firm fish, sliced and packed for curry or tawa fry."
  },
  {
    id: "hilasa",
    name: "Hilasa",
    category: "fish",
    price: 980,
    unit: "kg",
    image: "assets/hilasa.jpg",
    tag: "Seasonal",
    description: "Rich, flavorful fish for traditional curry and special orders."
  },
  {
    id: "pulasa",
    name: "Pulasa",
    category: "fish",
    price: 1450,
    unit: "kg",
    image: "assets/pulasa.jpg",
    tag: "Premium",
    description: "Premium seasonal fish, packed fresh for festival and family meals."
  },
  {
    id: "tiger-prawns",
    name: "Tiger Prawns",
    category: "prawns",
    price: 820,
    unit: "kg",
    image: "assets/tiger prawns.jpg",
    tag: "Cleaned",
    description: "Large prawns, deveined on request and packed chilled."
  },
  {
    id: "mud-crab",
    name: "Big Size Crab",
    category: "crab",
    price: 950,
    unit: "kg",
    image: "assets/small crab.jpg",
    tag: "Premium",
    description: "Fresh crab for masala, roast, soup, and family meals."
  },
  {
    id: "small-crab",
    name: "Small Size Crab",
    category: "crab",
    price: 520,
    unit: "kg",
    image: "assets/mediam crab.jpg",
    tag: "Small size",
    description: "Small fresh crabs, good for curry, fry, and daily seafood meals."
  },
  {
    id: "medium-crab",
    name: "Medium Size Crab",
    category: "crab",
    price: 720,
    unit: "kg",
    image: "assets/crab.jpg",
    tag: "Medium size",
    description: "Medium crabs with good meat, packed fresh for home cooking."
  },
  {
    id: "vannami",
    name: "Vannami",
    category: "prawns",
    price: 620,
    unit: "kg",
    image: "assets/tiger prawns.jpg",
    tag: "Fresh prawns",
    description: "Fresh Vannami prawns, cleaned and packed for curry or fry."
  },
  {
    id: "vannami-small",
    name: "Vannami Small",
    category: "prawns",
    price: 480,
    unit: "kg",
    image: "assets/tiger prawns.jpg",
    tag: "Small size",
    description: "Small Vannami prawns for daily cooking, fry, and gravy orders."
  }
];

const cart = new Map();
const productGrid = document.querySelector("#productGrid");
const categoryFilter = document.querySelector("#categoryFilter");
const cartItems = document.querySelector("#cartItems");
const cartTotal = document.querySelector("#cartTotal");
const orderForm = document.querySelector("#orderForm");
const orderSummary = document.querySelector("#orderSummary");
const clearCart = document.querySelector("#clearCart");

function money(value) {
  return new Intl.NumberFormat("en-IN", {
    style: "currency",
    currency: "INR",
    maximumFractionDigits: 0
  }).format(value);
}

function renderProducts() {
  const selectedCategory = categoryFilter.value;
  const visibleProducts = products.filter((product) => {
    return selectedCategory === "all" || product.category === selectedCategory;
  });

  productGrid.innerHTML = visibleProducts
    .map((product) => {
      return `
        <article class="product-card">
          <img src="${product.image}" alt="${product.name}">
          <div class="product-body">
            <span class="badge">${product.tag}</span>
            <div class="product-title">
              <h3>${product.name}</h3>
              <span class="price">${money(product.price)}/${product.unit}</span>
            </div>
            <p>${product.description}</p>
            <button class="button primary" type="button" data-add="${product.id}">
              Add to order
            </button>
          </div>
        </article>
      `;
    })
    .join("");
}

function renderCart() {
  if (cart.size === 0) {
    cartItems.innerHTML = `<div class="empty-cart">No seafood selected yet.</div>`;
    cartTotal.textContent = money(0);
    return;
  }

  let total = 0;
  cartItems.innerHTML = Array.from(cart.values())
    .map(({ product, quantity }) => {
      const rowTotal = product.price * quantity;
      total += rowTotal;
      return `
        <div class="cart-row">
          <div>
            <strong>${product.name}</strong>
            <span>${quantity} ${product.unit}</span>
          </div>
          <strong>${money(rowTotal)}</strong>
        </div>
      `;
    })
    .join("");

  cartTotal.textContent = money(total);
}

productGrid.addEventListener("click", (event) => {
  const button = event.target.closest("[data-add]");
  if (!button) return;

  const product = products.find((item) => item.id === button.dataset.add);
  const current = cart.get(product.id) || { product, quantity: 0 };
  current.quantity += 1;
  cart.set(product.id, current);
  orderSummary.textContent = "";
  renderCart();
});

categoryFilter.addEventListener("change", renderProducts);

clearCart.addEventListener("click", () => {
  cart.clear();
  orderSummary.textContent = "";
  renderCart();
});

orderForm.addEventListener("submit", (event) => {
  event.preventDefault();

  if (cart.size === 0) {
    orderSummary.textContent = "Please add at least one seafood item before creating an order.";
    return;
  }

  const data = new FormData(orderForm);
  const total = Array.from(cart.values()).reduce((sum, item) => {
    return sum + item.product.price * item.quantity;
  }, 0);

  orderSummary.textContent = `Order ready for ${data.get("name")} at ${data.get("time")}. Estimated total: ${money(total)}. Call ${data.get("phone")} to confirm delivery.`;
  orderForm.reset();
});

renderProducts();
renderCart();
