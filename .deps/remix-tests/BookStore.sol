// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.22 <0.9.0;

// event - notify of new addition or act as audit trail


contract BookStore {

    address public owner;

    
    // group items
    struct Book {
        string title;
        string author;
        uint price;
        uint256 stock;
        bool isAvailable;
    }

    // store items with their unique id
    mapping (uint256 => Book) public books;
    uint256 [] public bookIds;

    event BookAdded(uint256 bookId, string title, string author, uint256 price, uint stock);
    event BookPurchase(uint256 indexed bookId, address indexed buyer, uint256 quantity);


    constructor () {
        owner  = msg.sender;
    }

    function addBook(uint256 _bookId, string memory _title, string memory _author, uint256 _price, uint256 _stock) public  {

        require(books[_bookId].price == 0, "Book already exists with this ID.");

        books[_bookId] = Book({

            title: _title,

            author: _author,

            price: _price,

            stock: _stock,

            isAvailable: _stock > 0

        });

        bookIds.push(_bookId); // push() , remove()

        emit BookAdded(_bookId, _title, _author, _price, _stock);
    }

    function getBooks(uint256 _bookId) public view returns (string memory, string memory, uint256, uint256, bool) {

        Book memory book = books[_bookId];

        return (book.title, book.author, book.price, book.stock, book.isAvailable);

    }

    function buyBook(uint256 _bookId, uint256 _quantity) public payable {

        Book storage book = books[_bookId];

        require(book.isAvailable, "This book is not available.");

        require(book.stock >= _quantity, "Not enough stock available.");

        require(msg.value == book.price * _quantity, "Incorrect payment amount.");

        // Decrease stock and update availability

        book.stock -= _quantity;

        if (book.stock == 0) {

            book.isAvailable = false;

        }

        // Transfer payment to the owner - paybale == transfer(from, to, amount)

        payable(owner).transfer(msg.value);

        emit BookPurchased(_bookId, msg.sender, _quantity);

    }

    }
    