document.addEventListener('DOMContentLoaded', function() {
    // --- Language Toggle Functionality (for attribute detail pages) ---
    const showEnBtn = document.getElementById('show-en-btn');
    const showDeBtn = document.getElementById('show-de-btn');
    const showBothBtn = document.getElementById('show-both-btn');

    function updateActiveButton(activeId) {
        document.querySelectorAll('.lang-buttons button').forEach(btn => {
            btn.classList.remove('active');
        });
        const activeButton = document.getElementById(activeId);
        if (activeButton) {
            activeButton.classList.add('active');
        }
    }

    function setLangClass(lang) {
        document.body.classList.remove('show-en', 'show-de', 'show-both');
        document.body.classList.add(lang);
    }

    if (showEnBtn) {
        showEnBtn.addEventListener('click', function() {
            setLangClass('show-en');
            updateActiveButton('show-en-btn');
        });
    }

    if (showDeBtn) {
        showDeBtn.addEventListener('click', function() {
            setLangClass('show-de');
            updateActiveButton('show-de-btn');
        });
    }

    if (showBothBtn) {
        showBothBtn.addEventListener('click', function() {
            setLangClass('show-both');
            updateActiveButton('show-both-btn');
        });
    }

    // Set initial state for detail pages
    if (document.body.contains(showBothBtn)) {
        updateActiveButton('show-both-btn');
    }

    // --- Download Functionality (for both index and detail pages) ---
    const downloadCsvBtn = document.getElementById('download-csv-btn');
    const downloadAdocBtn = document.getElementById('download-adoc-btn');

    if (downloadCsvBtn) {
        downloadCsvBtn.addEventListener('click', function() {
            const link = document.createElement('a');
            // The path is relative to the docs/attribute_pages/ folder
            link.href = '../../data/epd_documentation.csv';
            link.download = 'epd_documentation.csv';
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        });
    }

    if (downloadAdocBtn) {
        downloadAdocBtn.addEventListener('click', function() {
            const link = document.createElement('a');
            // The path is relative to the docs/attribute_pages/ folder
            link.href = '../../data/epd_documentation_from_xlsx_combined.adoc';
            link.download = 'epd_documentation_from_xlsx_combined.adoc';
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        });
    }
});
