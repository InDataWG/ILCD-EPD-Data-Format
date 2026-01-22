/**
 * Interactive functionality for schemadoc documentation pages.
 */
document.addEventListener('DOMContentLoaded', function() {
    const searchBar = document.getElementById('search-bar');
    const tableRows = document.querySelectorAll('tbody tr');
    const toggleStripesBtn = document.getElementById('toggle-stripes-btn');
    const table = document.getElementById('report-table');

    // --- Zebra Stripe Toggling ---
    if (table) table.classList.add('table-striped');

    if (toggleStripesBtn) {
        toggleStripesBtn.addEventListener('click', () => {
            if (table) table.classList.toggle('table-striped');
        });
    }

    // --- Function to open attribute detail page ---
    window.openAttributePage = function(attributePath) {
        // Sanitize the path to create a valid filename
        const sanitizedFilename = attributePath.replace(/[^a-zA-Z0-9._-]/g, '_') + '.html';
        const relativePath = `attribute_pages/${sanitizedFilename}`;
        window.open(relativePath, '_blank');
    };

    // --- Search functionality ---
    if (searchBar) {
        searchBar.addEventListener('keyup', () => {
            const searchTerm = searchBar.value.toLowerCase();
            
            tableRows.forEach(row => {
                // Search across all visible text in the row
                const rowText = row.textContent.toLowerCase();
                const path = (row.dataset.tooltip || '').toLowerCase();
                
                const isMatch = rowText.includes(searchTerm) || path.includes(searchTerm);
                row.style.display = isMatch ? '' : 'none';
            });
        });
    }

    // --- Column Toggle functionality ---
    const colToggles = document.querySelectorAll('.col-toggles input[type="checkbox"]');
    colToggles.forEach(function(checkbox) {
        checkbox.addEventListener('change', function() {
            const colName = this.getAttribute('data-col');
            if (!colName) return;
            
            // Only hide/show table cells, not the checkbox itself
            const cells = document.querySelectorAll(`table [data-col="${colName}"]`);
            cells.forEach(cell => {
                cell.style.display = this.checked ? '' : 'none';
            });
        });
    });

    // --- Download functionality ---
    const downloadCsvBtn = document.getElementById('download-csv-btn');
    const downloadAdocBtn = document.getElementById('download-adoc-btn');
    
    // Get the current page name for file downloads
    const pageName = window.location.pathname.split('/').pop().replace('.html', '');
    
    if (downloadCsvBtn) {
        downloadCsvBtn.addEventListener('click', function() {
            // Generate CSV from the table
            const table = document.getElementById('report-table');
            if (!table) return;
            
            const rows = table.querySelectorAll('tr');
            let csv = [];
            
            rows.forEach((row, index) => {
                const cells = row.querySelectorAll('th, td');
                const rowData = [];
                cells.forEach(cell => {
                    // Skip "View Attribute" column
                    if (cell.getAttribute('data-col') === 'View Attribute') return;
                    // Get text content, escape quotes
                    let text = cell.textContent.trim().replace(/"/g, '""');
                    // Wrap in quotes if contains comma or newline
                    if (text.includes(',') || text.includes('\n') || text.includes('"')) {
                        text = `"${text}"`;
                    }
                    rowData.push(text);
                });
                csv.push(rowData.join(','));
            });
            
            // Create and trigger download
            const blob = new Blob([csv.join('\n')], { type: 'text/csv;charset=utf-8;' });
            const link = document.createElement('a');
            link.href = URL.createObjectURL(blob);
            link.download = `${pageName}.csv`;
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        });
    }
    
    if (downloadAdocBtn) {
        downloadAdocBtn.addEventListener('click', function() {
            // Download the source AsciiDoc file
            const link = document.createElement('a');
            link.href = `data/${pageName}.adoc`;
            link.download = `${pageName}.adoc`;
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        });
    }
});
