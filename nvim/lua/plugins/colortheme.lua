return {
	"EdenEast/nightfox.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		-- Load the colorscheme
		require("nightfox").setup({
			options = {
				transparent = true,
				styles = {
					comments = "italic",
					keywords = "bold",
					functions = "italic,bold",
				},
			},
		})
		vim.cmd("colorscheme duskfox") -- Use the desired theme (e.g., nightfox)
	end,
}
