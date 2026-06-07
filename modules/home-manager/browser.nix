{ ... } : {
    programs.firefox = {
        enable = true;
        profiles.default = {
            settings = {
                "browser.search.region" = "PL";
            };
        };
    };
}
