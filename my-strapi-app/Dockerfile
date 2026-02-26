FROM node:20-alpine

# Create app directory
WORKDIR /app

ENV NODE_ENV=production

# Copy package files first (better caching)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy project files
COPY . .         

# Build Strapi admin panel
RUN npm run build

# Expose Strapi port
EXPOSE 1337

# Start Strapi
CMD ["npm", "run", "start"]

  
  