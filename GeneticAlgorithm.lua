local function initPopulation(amountOfIndividuals, amountOfChromosomesPerIndividual, target)
	local populationArray = {}
	for i=1, amountOfIndividuals do
		populationArray[i] = {} --individual
		for k=1, amountOfChromosomesPerIndividual do
			local chromosome = {}
			local targetArray = string.split(target, "")
			for i=1, #targetArray do
				chromosome[i] = math.random(1,26) -- alphabet is 26 chars long
			end
			populationArray[i][k] = chromosome
		end
	end
	return populationArray
end

local function computeFitness(population)
	local fitnessOfGeneration = {}
	for _, individual in pairs(population) do
		for _, chromosome in pairs(individual) do
			local fitness = 0
			for gene=1,#chromosome do
				if gene == 1 and chromosome[gene] == 3 then
					fitness += 1
				elseif gene == 2 and chromosome[gene] == 1 then
					fitness += 1
				elseif gene == 3 and chromosome[gene] == 2 then
					fitness += 1
				end
			end
			table.insert(fitnessOfGeneration, {chromosome, fitness})
		end
	end

	return fitnessOfGeneration
end

local function selectMatingPool(fitnessOfGeneration)
	local fitnessSigma = 0
	local matingPool = {}
	for individual=1, #fitnessOfGeneration do
		fitnessSigma += fitnessOfGeneration[individual][2]
	end
	for individual=1, #fitnessOfGeneration do
		table.insert(matingPool, {fitnessOfGeneration[individual][1], fitnessOfGeneration[individual][2]/fitnessSigma})
	end
	local mates = {{}, {}}
	for individual=1, #fitnessOfGeneration do
		if not mates[1][1] then
			mates[1] = fitnessOfGeneration[individual]
		end
		if not mates[2][2] then
			mates[2] = fitnessOfGeneration[individual]
		end
		if mates[1][2] < fitnessOfGeneration[individual][2] and fitnessOfGeneration[individual][2] ~= mates[2][2] then
			mates[1] = fitnessOfGeneration[individual]
		elseif mates[2][2] < fitnessOfGeneration[individual][2] and fitnessOfGeneration[individual][2] ~= mates[1][2] then
			mates[2] = fitnessOfGeneration[individual]
		end
	end

	return mates
end

local population = initPopulation(10,1, "cab") --Target numeral = 3 1 2
local fitnessOfGeneration = computeFitness(population)
print(selectMatingPool(fitnessOfGeneration))