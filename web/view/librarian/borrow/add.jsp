<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<style>

    .request-wrapper{
        padding:20px;
    }

    .page-title{
        font-size:22px;
        margin-bottom:20px;
    }

    /* CARD */

    .card{
        background:white;
        padding:25px;
        border-radius:10px;
        box-shadow:0 3px 12px rgba(0,0,0,0.08);
        max-width:700px;
    }

    /* FORM */

    .form-group{
        margin-bottom:15px;
    }

    .form-group label{
        display:block;
        margin-bottom:5px;
        font-weight:600;
    }

    .form-group input,
    .form-group select{
        width:100%;
        padding:8px 10px;
        border:1px solid #ddd;
        border-radius:5px;
    }

    /* BOOK LIST */

    .book-list{
        margin-top:10px;
    }

    .book-item{
        display:flex;
        justify-content:space-between;
        align-items:center;
        background:#f9f9f9;
        padding:8px 10px;
        border-radius:5px;
        margin-bottom:5px;
    }

    /* BUTTON */

    .btn{
        border:none;
        padding:8px 14px;
        border-radius:5px;
        cursor:pointer;
    }

    .btn-primary{
        background:#ff7a00;
        color:white;
    }

    .btn-primary:hover{
        background:#e56a00;
    }

    .btn-remove{
        background:#dc3545;
        color:white;
        font-size:12px;
        padding:4px 8px;
    }

    /* ADD BOOK */

    .add-book{
        display:flex;
        gap:10px;
    }

</style>

<div class="request-wrapper">

    <h2 class="page-title">Create Borrow Request</h2>

    <div class="card">

        <form method="post" action="${pageContext.request.contextPath}/librarian/request/add">

            <!-- READER -->
            <div class="form-group">
                <label>Reader</label>
                <select name="readerId" required>

                    <option value="">-- Select Reader --</option>

                    <c:forEach var="r" items="${readerList}">
                        <option value="${r.readerId}">
                            ${r.fullName} (${r.email})
                        </option>
                    </c:forEach>

                </select>
            </div>

            <!-- NOTE -->
            <div class="form-group">
                <label>Note</label>
                <input type="text" name="note" placeholder="Optional note">
            </div>

            <!-- ADD BOOK -->
            <div class="form-group">

                <label>Add Book</label>

                <div class="add-book">

                    <select id="bookSelect">

                        <option value="">-- Select Book --</option>

                        <c:forEach var="b" items="${bookList}">
                            <option value="${b.bookId}" data-title="${b.title}">
                                ${b.title} - ${b.isbn}
                            </option>
                        </c:forEach>

                    </select>

                    <input type="number" id="quantityInput" value="1" min="1">

                    <button type="button" class="btn btn-primary" onclick="addBook()">
                        Add
                    </button>

                </div>

            </div>

            <!-- BOOK LIST -->
            <div class="form-group">

                <label>Selected Books</label>

                <div id="bookList" class="book-list">
                    <!-- dynamic -->
                </div>

            </div>

            <br>

            <button class="btn btn-primary">
                Create Request
            </button>

        </form>

    </div>

</div>

<script>

    let selectedBooks = [];

    function addBook() {

        const select = document.getElementById("bookSelect");
        const quantityInput = document.getElementById("quantityInput");

        // ===== LẤY OPTION =====
        const option = select.selectedOptions[0];

        // ===== TÁCH BIẾN =====
        let bookId = option ? option.value : null;
        let bookTitle = option ? option.textContent.trim() : "";
        let qty = quantityInput.value;

        // ===== DEBUG =====
        console.log("DEBUG:", {
            bookId: bookId,
            bookTitle: bookTitle,
            qty: qty
        });

        // ===== VALIDATE =====
        if (!bookId) {
            alert("Please select a book");
            return;
        }

        if (!qty || qty <= 0) {
            alert("Invalid quantity");
            return;
        }

        // convert
        bookId = parseInt(bookId);
        qty = parseInt(qty);

        // ===== ADD / MERGE =====
        let existing = selectedBooks.find(b => b.id === bookId);

        if (existing) {
            existing.quantity += qty;
        } else {
            selectedBooks.push({
                id: bookId,
                title: bookTitle,
                quantity: qty
            });
        }

        renderBooks();

        // reset
        quantityInput.value = 1;
        select.selectedIndex = 0;
    }

    function removeBook(index) {
        selectedBooks.splice(index, 1);
        renderBooks();
    }

    function renderBooks() {

        const container = document.getElementById("bookList");
        container.innerHTML = "";

        if (selectedBooks.length === 0) {
            container.innerHTML = "<span style='color:#888'>No books selected</span>";
            return;
        }

        selectedBooks.forEach((book, index) => {

            // ===== TÁCH BIẾN (QUAN TRỌNG) =====
            let title = book.title || "Unknown";
            let qty = book.quantity || 0;

            console.log("RENDER:", title, qty);

            const div = document.createElement("div");
            div.className = "book-item";

            const span = document.createElement("span");
            span.textContent = title + " (x" + qty + ")";

            const btn = document.createElement("button");
            btn.type = "button";
            btn.className = "btn-remove";
            btn.textContent = "Remove";
            btn.onclick = () => removeBook(index);

            const inputBook = document.createElement("input");
            inputBook.type = "hidden";
            inputBook.name = "bookId";
            inputBook.value = book.id;

            const inputQty = document.createElement("input");
            inputQty.type = "hidden";
            inputQty.name = "quantity";
            inputQty.value = qty;

            div.appendChild(span);
            div.appendChild(btn);
            div.appendChild(inputBook);
            div.appendChild(inputQty);

            container.appendChild(div);
        });
    }

</script>
