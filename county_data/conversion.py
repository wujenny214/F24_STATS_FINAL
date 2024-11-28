import pandas as pd
import os

# Directory containing CSV files
input_directory = "/Users/jw/F24_STATS_FINAL/county_data"  # Replace with your CSV directory path
output_directory = "/Users/jw/F24_STATS_FINAL/county_data"  # Replace with your output directory path


# Create output directory if it doesn't exist
os.makedirs(output_directory, exist_ok=True)

# Loop through all files in the input directory
for filename in os.listdir(input_directory):
    if filename.endswith('.csv'):
        csv_path = os.path.join(input_directory, filename)
        xlsx_path = os.path.join(output_directory, f"{os.path.splitext(filename)[0]}.xlsx")
        
        # Read the CSV with the second row as the header
        df = pd.read_csv(csv_path, header=1)
        
        # Save to Excel with the specified sheet name
        with pd.ExcelWriter(xlsx_path, engine='openpyxl') as writer:
            df.to_excel(writer, sheet_name="Additional Measure Data", index=False)
        
        print(f"Converted: {csv_path} -> {xlsx_path} with sheet title 'Additional Measure Data' and second row as header")

print("All CSV files have been converted to XLSX format with the specified sheet name.")