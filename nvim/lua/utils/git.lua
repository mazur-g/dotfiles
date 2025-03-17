local M = {}

function M.parse_git_diff(diff_output)
	local hunks = {}
	local current_hunk = nil

	for line in diff_output:gmatch("[^\r\n]+") do
		if line:match("^%-%-%-") or line:match("^%+%+%+") then
			if current_hunk then
				if next(current_hunk.lines) ~= nil then
					table.insert(hunks, current_hunk)
				end
			end
			current_hunk = { filename = line:sub(5), lines = {} }
		elseif line:match("^@@") then
			local start, count = line:match("%+(%d+),?(%d*)")
			if (next(current_hunk.lines) ~= nil) then
				table.insert(hunks, current_hunk)
				current_hunk = {
					header = line,
					lines = {},
					filename = current_hunk.filename,
					line_start =
					    tonumber(start),
					line_end = tonumber(start) + (tonumber(count) or 1) - 1
				}
			else
				current_hunk.header = line
				current_hunk.line_start = tonumber(start)
				current_hunk.line_end = tonumber(start) + (tonumber(count) or 1) - 1
			end
		elseif line:match("^diff %-%-git") or line:match("^index") then
			-- Ignore these lines
		elseif current_hunk then
			table.insert(current_hunk.lines, line)
		end
	end

	if current_hunk then
		table.insert(hunks, current_hunk)
	end

	return hunks
end

function M.print_hunks(hunks)
	for _, hunk in ipairs(hunks) do
		for _, l in ipairs(hunk.lines) do
			print("    " .. l)
		end
	end
end

function M.grep_branch_changed_lines()
	local diff_output = [[
diff --git a/apps/optimizer_ecto/lib/orex_data/reporting/utils/product_forecast.ex b/apps/optimizer_ecto/lib/orex_data/reporting/utils/product_forecast.ex
index 123abc..456def 100644
--- apps/optimizer_ecto/lib/orex_data/reporting/utils/product_forecast.ex
+++ apps/optimizer_ecto/lib/orex_data/reporting/utils/product_forecast.ex
@@ -14 +14,2 @@ defmodule OrEx.Data.Reporting.Utils.ProductForecast do
-  alias OrEx.Data.Reporting.EmbeddedSchemas.ProductForecastFilters, as: Filters
+  alias Test
+  alias OrEx.Data.Reporting.EmbeddedSchemas.ProductForecastFilters, as: Filtersorowowow

diff --git a/apps/optimizer_ecto/lib/orex_data/reporting/utils/another_file.ex b/apps/optimizer_ecto/lib/orex_data/reporting/utils/another_file.ex
index 789ghi..012jkl 100644
--- apps/optimizer_ecto/lib/orex_data/reporting/utils/another_file.ex
+++ apps/optimizer_ecto/lib/orex_data/reporting/utils/another_file.ex
@@ -50,2 +50,3 @@ defmodule AnotherModule do
-  def old_function do
-    :ok
+  def new_function do
+    :updated
+    :ok

@@ -100 +101 @@ defmodule AnotherModule do
-  IO.puts("Old line")
+  IO.puts("New line")
]]

	local hunks = M.parse_git_diff(diff_output)
	M.print_hunks(hunks)
end

return M
