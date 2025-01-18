import os
import shutil

def find_iptables_save_files(root_dir):
    iptables_save_files = []
    for dirpath, dirnames, filenames in os.walk(root_dir):
        for filename in filenames:
            if "iptables-save" in filename:
                iptables_save_files.append(os.path.join(dirpath, filename))
    return iptables_save_files

def copy_files_to_directory(file_list, destination_dir):
    os.makedirs(destination_dir, exist_ok=True)
    for file_path in file_list:
        shutil.copy2(file_path, destination_dir)

if __name__ == "__main__":
    acl_dir = input("Enter the source directory for ACL files: ")
    output_dir = input("Enter the destination directory: ")
    iptables_files = find_iptables_save_files(acl_dir)
    copy_files_to_directory(iptables_files, output_dir)
    print(f"Copied {len(iptables_files)} files to {output_dir}")
