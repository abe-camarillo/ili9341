from PIL import Image

img = Image.open('media/LEGO_brick.png')
img = img.resize((320, 240))  # Adjust to your display size
img = img.convert('RGB')

# Convert entire image to RGB565 bytes at once
pixels = []
for r, g, b in img.getdata():
    rgb565 = ((r & 0xF8) << 8) | ((g & 0xFC) << 3) | (b >> 3)
    pixels.append(rgb565.to_bytes(2, 'little'))

# Join all bytes and write once
data = b''.join(pixels)

with open('/dev/fb0', 'wb') as fb:
    fb.write(data)
