<<<<<<< HEAD
﻿import sys
=======
import sys
>>>>>>> 07964905b73a354e8878854a2d94467b215e7a68
from markitdown import MarkItDown

input_file = sys.argv[1]
output_file = sys.argv[2]

md = MarkItDown()
result = md.convert(input_file)

with open(output_file, 'w', encoding='utf-8') as f:
    f.write(result.text_content)

print('OK', len(result.text_content), 'chars')
<<<<<<< HEAD

=======
>>>>>>> 07964905b73a354e8878854a2d94467b215e7a68
