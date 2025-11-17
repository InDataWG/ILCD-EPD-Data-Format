document.addEventListener('DOMContentLoaded', function() {
    const showEnBtn = document.getElementById('show-en-btn');
    const showDeBtn = document.getElementById('show-de-btn');
    const showAllBtn = document.getElementById('show-all-btn');
    const body = document.body;
    const searchBar = document.getElementById('search-bar');
    const tableRows = document.querySelectorAll('tbody tr');
    const toggleStripesBtn = document.getElementById('toggle-stripes-btn');
    const table = document.getElementById('report-table');

    // --- Zebra Stripe Toggling ---
    // Start with stripes on by default
    if (table) table.classList.add('table-striped');

    toggleStripesBtn.addEventListener('click', () => {
        if (table) table.classList.toggle('table-striped');
    });

    // --- Language Toggling with Column Toggle Filtering ---
    function updateColumnToggles(langClass) {
        const toggleLabels = document.querySelectorAll('.col-toggle-label');
        
        toggleLabels.forEach(label => {
            if (langClass === 'show-en') {
                // Show only English and neutral columns
                if (label.classList.contains('lang-de')) {
                    label.style.display = 'none';
                } else {
                    label.style.display = '';
                }
            } else if (langClass === 'show-de') {
                // Show only German and neutral columns
                if (label.classList.contains('lang-en')) {
                    label.style.display = 'none';
                } else {
                    label.style.display = '';
                }
            } else {
                // Show all columns (both languages)
                label.style.display = '';
            }
        });
    }

    showEnBtn.addEventListener('click', () => {
        body.className = 'show-en';
        updateColumnToggles('show-en');
    });

    showDeBtn.addEventListener('click', () => {
        body.className = 'show-de';
        updateColumnToggles('show-de');
    });

    showAllBtn.addEventListener('click', () => {
        body.className = ''; // Remove all classes to show both
        updateColumnToggles('');
    });
    
    // Initialize column toggles based on initial state
    updateColumnToggles('show-en'); // Default state is show-en

    // Function to open attribute detail page
    window.openAttributePage = function(attributePath) {
        // Sanitize the path to create a valid filename, matching the Python script's logic.
        const sanitizedFilename = attributePath.replace(/[^a-zA-Z0-9._-]/g, '_') + '.html';
        // Construct a relative path that works both locally and on GitHub Pages.
        const relativePath = `attribute_pages/${sanitizedFilename}`;
        window.location.href = relativePath;
    };

    searchBar.addEventListener('keyup', () => {
        const searchTerm = searchBar.value;
        const isPathSearch = searchTerm.includes('/');
        let searchRegex;

        try {
            // Create a case-insensitive regular expression
            searchRegex = new RegExp(searchTerm, 'i');
        } catch (e) {
            // If regex is invalid, it will be null
            searchRegex = null;
        }

        tableRows.forEach(row => {
            const elementNameCell = row.querySelector('[data-col="Element/Attribute Name"] .tooltip-wrapper');
            const elementName = elementNameCell ? elementNameCell.childNodes[elementNameCell.childNodes.length - 1].textContent : '';
            const path = row.dataset.tooltip || '';

            const targetText = isPathSearch ? path : elementName;
            let isMatch = false;

            if (searchRegex) {
                // Use regex test for matching
                isMatch = searchRegex.test(targetText);
            } else {
                // Fallback to simple text search if regex is invalid
                isMatch = targetText.toLowerCase().includes(searchTerm.toLowerCase());
            }

            row.style.display = isMatch ? '' : 'none';
        });
    });

    const colToggles = document.querySelectorAll('.col-toggle');
    colToggles.forEach(function(checkbox) {
        checkbox.addEventListener('change', function() {
            const colName = this.value;
            const cells = document.querySelectorAll(`[data-col="${colName}"]`);
            cells.forEach(cell => {
                cell.style.display = this.checked ? '' : 'none';
            });
        });
    });

    // Download functionality
    document.getElementById('download-csv-btn').addEventListener('click', function() {
        const link = document.createElement('a');
        link.href = '../data/epd_documentation.csv'; // Adjusted path
        link.download = 'epd_documentation.csv';
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
    });

    document.getElementById('download-adoc-btn').addEventListener('click', function() {
        const link = document.createElement('a');
        link.href = '../data/epd_documentation_from_xlsx_combined.adoc'; // Adjusted path
        link.download = 'epd_documentation_from_xlsx_combined.adoc';
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
    });
});
