import json
import csv
import os

def transform_json_to_csv(input_file, output_file):
    """
    Reads a JSON file containing customer data and flattens it into a CSV.
    
    Expected JSON structure:
    {
        "customers": [
            {
                "id": "CUS...",
                "loc": {
                    "locations": [
                        {
                            "locations": {
                                "IsPrimary": boolean,
                                "Phone": "...",
                                "Email": "...",
                                "Address1": "...",
                                "Address2": "..."
                            }
                        },
                        ...
                    ]
                }
            },
            ...
        ]
    }
    
    Output columns: CustomerId, IsPrimaryLocation, Phone, Email, Address
    """
    
    # keys for the output csv
    fieldnames = ['CustomerId', 'IsPrimaryLocation', 'Phone', 'Email', 'Address']
    
    rows = []
    
    try:
        with open(input_file, 'r') as f:
            data = json.load(f)
            
        customers = data.get('customers', [])
        
        for cust in customers:
            customer_id = cust.get('id')
            
            # Navigate to the list of locations
            # loc -> locations (list) -> item -> locations (dict)
            loc_data = cust.get('loc', {})
            locations_list = loc_data.get('locations', [])
            
            for loc_item in locations_list:
                # The actual details are inside a nested 'locations' key
                details = loc_item.get('locations', {})
                
                is_primary = str(details.get('IsPrimary', '')).lower()  # 'true' / 'false', matching the required output
                phone = details.get('Phone', '')
                email = details.get('Email', '')
                
                # Combine Address1 and Address2
                addr1 = details.get('Address1', '')
                addr2 = details.get('Address2', '')
                address = f"{addr1} {addr2}".strip()
                
                row = {
                    'CustomerId': customer_id,
                    'IsPrimaryLocation': is_primary,
                    'Phone': phone,
                    'Email': email,
                    'Address': address
                }
                rows.append(row)
                
        # Write to CSV: standard comma-separated, with a header row.
        # The csv module quotes any field that contains a comma, so addresses stay intact.
        with open(output_file, 'w', newline='', encoding='utf-8') as csvfile:
            writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
            writer.writeheader()
            writer.writerows(rows)
            
        print(f"Successfully transformed {len(rows)} records to {output_file}")
            
    except Exception as e:
        print(f"Error processing file: {e}")

if __name__ == "__main__":
    current_dir = os.path.dirname(os.path.abspath(__file__))
    input_json = os.path.join(current_dir, 'python_json_transform_data.json')
    output_csv = os.path.join(current_dir, 'python_json_transform_output.csv')
    
    transform_json_to_csv(input_json, output_csv)
